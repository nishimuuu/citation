# coding: utf-8
# 

require 'thor'
require 'pathname'
lib = Pathname.new(__FILE__).dirname.join().expand_path.to_s
$:.unshift lib
require 'citation'
require 'json'

module EntryPoint
  class CLI < Thor
    include Citation
    class_option 'f', type: :string, aliases: 'Output format', desc: 'Set outputformat(default: "bibtex")', default: 'bibtex'
    class_option 'r', type: :boolean, aliases: 'Recursive', desc: 'Turn on recursive mode(default: false)' , default: false

    desc 'instr', 'set citation string'
    def instr(s)
      puts Citation.parse(s, options[:r]).out(options[:f])
    end
  end
end
