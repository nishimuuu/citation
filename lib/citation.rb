require "citation/version"
require 'pathname'
lib = Pathname.new(__FILE__).dirname.join().expand_path.to_s
$:.unshift lib

require 'citation/version'
require 'citation/entrypoint'
module Citation
  # Your code goes here...
end
