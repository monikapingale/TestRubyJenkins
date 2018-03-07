# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "EnziMailUtility/version"

Gem::Specification.new do |spec|
  spec.name          = "enziMailUtility"
  spec.version       = EnziMailUtility::VERSION
  spec.authors       = ["Monika Pingale"]
  spec.email         = ["monika.pingale@enzigma.in"]
  spec.homepage      = 'https://rubygems.org/gems/example'
  spec.summary       = "This gem is used to send email"
  spec.description   = "This gem is used to send email from any domain to gamil"
  spec.license       = "MIT"

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency 'mail', '~> 2.7', '>= 2.7.0'
end
