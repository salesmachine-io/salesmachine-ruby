# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require 'salesmachine-ruby/version.rb'

Gem::Specification.new do |spec|
  spec.name        = "salesmachine-ruby"
  spec.version     = SalesMachine::VERSION
  spec.authors     = ["SalesMachine.IO"]
  spec.email       = ["support@salesmachine.io"]
  spec.homepage    = "https://www.salesmachine.io"
  spec.summary     = %q{Ruby bindings for the SalesMachine API}
  spec.description = 'The official SalesMachine tracking library for ruby'
  spec.license     = "MIT"
  spec.rubyforge_project = "salesmachine"

  spec.files = Dir.glob(`git ls-files`.split("\n"))
  spec.require_paths = ["lib"]

  spec.add_development_dependency('rake')
  spec.add_development_dependency('rspec')
  spec.add_development_dependency('webmock')
end
