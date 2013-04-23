# -*- coding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sinatra/cas/client/version'

Gem::Specification.new do |spec|
  spec.name          = "sinatra-cas-client"
  spec.version       = Sinatra::Cas::Client::VERSION
  spec.authors       = ["Simon Octal"]
  spec.email         = ["sioctal@gmail.com"]
  spec.description   = %q[Sinatra Extension Sinatra::CAS::Client]
  spec.summary       = %q[RubyCAS-Client for Sinatra]
  spec.homepage      = "https://github.com/sioctal/sinatra-cas-client"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'rubycas-client'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
