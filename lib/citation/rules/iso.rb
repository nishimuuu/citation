require 'pathname'
lib = Pathname.new(__FILE__).dirname.join().expand_path.to_s
$:.unshift lib
require 'base'

class ISO < RuleBase
  def self.satisfy?(string, base)
    @matcher = string.match(/, \.$/)
    base.type.empty? and not @matcher.nil?
  end

  def self.fetch(string, base)
    s = string.gsub(/ ([A-Z]). /,'_\1_ ')
    string.gsub!('()','')
    arr = s.split('. ')
    author = arr.shift.gsub(/_([A-Z])_ /,' \1. ')
    title = arr.shift if title == '' or title.nil?
    desc = arr.shift
    type = 'ISO 6900'.to_sym
    return string, title, author, desc, type
  end
end
