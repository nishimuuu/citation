require 'pathname'
lib = Pathname.new(__FILE__).dirname.join().expand_path.to_s
$:.unshift lib
require 'base'

class MLA < RuleBase
  def self.satisfy?(string, base)
    @matcher = string.match(/".+"/)
    !@matcher.nil?
  end

  def self.fetch(string, base)
    title = @matcher[0]
    string.slice!('()')
    s = string.split(title)
    string.slice!(title)
    title.gsub!('"','')

    author = s.shift
    desc   = s.shift
    type   = 'MLA'.to_sym
    string.slice!(author) unless string.empty?
    string.slice!(desc) unless string.empty?
    return string, title, author, desc, type
  end
end
