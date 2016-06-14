require 'pathname'
lib = Pathname.new(__FILE__).dirname.join().expand_path.to_s
$:.unshift lib
require 'uri'
require 'time'
require 'rules/mla'
require 'rules/apa'
require 'rules/iso'

module Citation
  class Base
    attr_accessor :year, :sq, :desc, :url, :author, :title, :type 
    def initialize
      @year = ''
      @sq   = ''
      @url  = ''
      @desc = ''
      @author = ''
      @title = ''
      @type = ''
    end

    def puts
     return {year: @year, sq: @sq, desc: @desc, author: @author, title: @title, type: @type}
    end

    def out(format)
      str = ''
      case format.downcase
      when 'MLA'
        str = "#{@author} \"#{@title}\" #{@desc} (#{@year})"
      when 'APA'
        str = "#{@author} (#{@year}) #{@title} #{@desc}"
      when 'ISO'
        str = "#{@author} #{@title} #{@desc}, #{@year}."
      when 'bibtex'
        str = "@article{#{@author.gsub(' ','').gsub(/( |\.|,)/,'').downcase[0..5]}#{@year}#{@title.split.select{|i| i.length >3 }[0].downcase},
        title={#{@title}},
        author={#{@author.gsub(', and ',', ')}},
        year={#{@year}},
        journal={#{@desc}}
        }"
      end
      str
    end
  end

  def self.parse(str, recursive=false)
    base = Base.new
    string = str.dup
    urls = URI.extract(string, %w(http https))
    urls.each do | url |
      string.slice!(url)
    end
    base.url = urls
   
    # fetch square bracket
    bracket_matcher = string.match(/\[([a-zA-Z0-9_ ]).+\]/)
    base.sq = bracket_matcher[0] unless bracket_matcher.nil?
    string.slice!(base.sq)
 
    # fetch year
    year_matcher = string.scan(/\d{4}/)
    base.year = year_matcher.
      map(&:to_i).
      select{|i| i > 1970 and i < Time.now.year}.
      shift.to_s unless year_matcher.nil?
    string.slice!(base.year)
 
    # fetch title if format is MLA
    if MLA.satisfy?(string, base)
      string, base.title, base.author, base.desc, base.type = MLA.fetch(string, base)
    end

    if APA.satisfy?(string, base)
      string, base.title, base.author, base.desc, base.type = APA.fetch(string, base)
    end


    if ISO.satisfy?(string, base)
      string, base.title, base.author, base.desc, base.type = ISO.fetch(string, base)
    end


    # fetch other
    if base.type.empty?
      s = string.gsub(/ ([A-Z]).,{0,1} /,'_\1_ ')
      s.gsub!('()','')
      arr = s.split('. ')
      base.author = arr.shift.gsub(/_([A-Z])_ /,' \1. ')
      base.title = arr.shift if base.title == '' or base.title.nil?
      base.desc = arr.join(' ')
    end
    return base
    
  end

end

if __FILE__ == $0
  test = '[B ́at09]  Norbert B ́atfai. On the Running Time of the Shortest Programs. CoRR, abs/0908.1159, 2009. http://arxiv.org/abs/0908.1159.'
  p Citation.parse(test, false)
  # MLA
  test = 'Bátfai, Norbert. "A disembodied developmental robotic agent called Samu B\'atfai." arXiv preprint arXiv:1511.02889 (2015).'
  p Citation.parse(test, false)

  # APA
  test = 'Bátfai, N. (2015). A disembodied developmental robotic agent called Samu B\'atfai. arXiv preprint arXiv:1511.02889.'
  p Citation.parse(test, false)
 
  # ISO 690
  test = 'BÁTFAI, Norbert. A disembodied developmental robotic agent called Samu B\'atfai. arXiv preprint arXiv:1511.02889, 2015.'
  p Citation.parse(test, false)
  test = 'MacKay, D. J. C., & Peto, L. C. B. (1995). A hierarchical Dirichlet language model. Natural Language Engineer- ing, 1, 289–307.'
  p Citation.parse(test, false)
  test = '[20] Y. Teh, M. Jordan, M. Beal, and D. Blei. Hierarchical Dirichlet processes. Journal of the American Statistical Association, 101(476):1566–1581, 2007.'
  p Citation.parse(test,false).out('bibtex')
end
