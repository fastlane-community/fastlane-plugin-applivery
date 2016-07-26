# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/applivery/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-applivery'
  spec.version       = Fastlane::Applivery::VERSION
  spec.author        = %q{Alejandro Jimenez}
  spec.email         = %q{a.j.agudo@gmail.com}

  spec.summary       = %q{Upload new build to Applivery}
  spec.homepage      = "https://github.com/applivery/fastlane-applivery-plugin"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  # spec.add_dependency 'your-dependency', '~> 1.0.0'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'fastlane', '>= 1.98.0'
end
