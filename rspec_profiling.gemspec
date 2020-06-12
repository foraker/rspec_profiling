# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec_profiling/version'

Gem::Specification.new do |spec|
  spec.name          = "rspec_profiling"
  spec.version       = RspecProfiling::VERSION
  spec.authors       = ["Ben Eddy"]
  spec.email         = ["bae@foraker.com"]
  spec.description   = %q{Profile RSpec test suites}
  spec.summary       = %q{Profile RSpec test suites}
  spec.homepage      = "https://github.com/foraker/rspec_profiling"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord"
  spec.add_dependency "rails"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
