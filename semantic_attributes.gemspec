# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = 'semantic_attributes'
  s.version = "1.0.0"
  s.authors = ["Lance Ivy"]
  s.email = 'lance@kickstarter.com'
  s.platform = Gem::Platform::RUBY
  s.homepage = %q{http://github.com/kickstarter/semantic-attributes}
  s.require_paths = ["lib"]
  s.summary = 'A validation library that allows introspection' +
    '(User.name_is_required?) and supports database normalization ' + 
    '(aka "form input cleaning").'
  
  s.add_dependency "activerecord", ">= 3.0.12"

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rake", "0.8.7"
  s.add_development_dependency "mocha", ">= 0.10.5"

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- test/*`.split("\n")
end

