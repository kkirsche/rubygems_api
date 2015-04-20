# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubygems_api/version'

Gem::Specification.new do |spec|
  spec.name          = 'rubygems_api'
  spec.version       = Rubygems::API::VERSION
  spec.authors       = ['Kevin Kirsche']
  spec.email         = ['kevin.kirsche@verizon.com']

  spec.summary       = %q{RubyGems v1 API client.}
  spec.description   = %q{Full featured RubyGems v1 API client using Hurley.}
  spec.homepage      = 'https://github.com/kkirsche/rubygems_api'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split('\x0').reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rake', '~> 10.4'
  spec.add_development_dependency 'minitest', '>= 5.6'
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 0.4'
  spec.add_runtime_dependency 'hurley', '~> 0'
end
