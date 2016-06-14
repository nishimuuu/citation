
require 'pathname'
lib = Pathname.new(__FILE__).dirname.join().expand_path.to_s
$:.unshift lib
require 'base'

class APA < RuleBase
  def self.satisfy?(string, base)
    @matcher = string.match(/\(\)\. .+\. /)
    base.type.empty? and not @matcher.nil?
  end

  def self.fetch(string, base)
    title = @matcher[0] unless @matcher.nil?
    title.gsub!(/"|\(\)\. /,'')
    string.slice!(title)

    s = string.split('(). ')
    author = s.shift
    desc   = s.shift
    type   = 'APA'.to_sym
    string.slice!(author) unless string.empty?
    string.slice!(desc) unless string.empty?
    return string, title, author, desc, type
  end
end
