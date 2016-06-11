# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'citation/version'

Gem::Specification.new do |spec|
  spec.name          = "citation"
  spec.version       = Citation::VERSION
  spec.authors       = ["Takahiro Nishimura"]
  spec.email         = ["tkhr.nishimura@gmail.com"]

  spec.summary       = %q{Parse citation in paper}
  spec.description   = %q{For fetching citation list in paper, it is very exhausted process; open pdf file, scroll page harder, copy and paste google scholar. This gem library is specify to parse flat-citation list to strucutured format such as BiBTex to easy to refer to your paper, survey paper and so on. }
  spec.homepage      = "https://github.com/nishimuuu/citation"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_dependency 'thor', '~> 0.19' 
end
