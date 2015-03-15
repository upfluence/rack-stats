# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/stats/version'

Gem::Specification.new do |spec|
  spec.name          = "rack-stats"
  spec.version       = Rack::Stats::VERSION
  spec.authors       = ["Alexis Montagne"]
  spec.email         = ["alexis.montagne@gmail.com"]
  spec.summary       = %q{Customisable rack middleware to instrument to instrument your application}
  spec.description   = %q{Customisable rack middleware to instrument to instrument your application}
  spec.homepage      = "https://github.com/upfluence/rack-stats"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_runtime_dependency "statsd-ruby"
  spec.add_runtime_dependency "rack"
end
