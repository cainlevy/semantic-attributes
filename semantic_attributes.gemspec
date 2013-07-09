$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "semantic_attributes/version"

Gem::Specification.new do |s|
  s.name = 'semantic_attributes'
  s.version = SemanticAttributes::VERSION
  s.authors = ["Lance Ivy"]
  s.email = 'lance@kickstarter.com'
  s.platform = Gem::Platform::RUBY
  s.homepage = %q{http://github.com/kickstarter/semantic-attributes}
  s.require_paths = ["lib"]
  s.summary = 'A validation library for ActiveRecord models.'
  s.description = 'A validation library for ActiveRecord models that allows ' + 
    'introspection (User.name_is_required?) and supports database' +
    ' normalization (aka "form input cleaning").'

  s.add_dependency "rails", ">= 3.2.13"

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rake", ">= 0.8.7"
  s.add_development_dependency "mocha", ">= 0.10.5"

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- test/*`.split("\n")
end
