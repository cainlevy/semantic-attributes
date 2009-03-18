ENV["RAILS_ENV"] = "test"

# load the support libraries
require 'test/unit'
require 'rubygems'
gem 'rails', '2.3.2'
require 'active_record'
require 'active_record/fixtures'
require 'mocha'

# establish the database connection
ActiveRecord::Base.configurations = YAML::load(IO.read(File.dirname(__FILE__) + '/db/database.yml'))
ActiveRecord::Base.establish_connection('semantic_attributes_test')

# capture the logging
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/test.log")

# load the code-to-be-tested
ActiveSupport::Dependencies.load_paths << File.dirname(__FILE__) + '/../lib/'
$LOAD_PATH.unshift         File.dirname(__FILE__) + '/../lib/'
require File.dirname(__FILE__) + '/../init'

# load the schema ... silently
ActiveRecord::Migration.verbose = false
load(File.dirname(__FILE__) + "/db/schema.rb")

# load the ActiveRecord models
require File.dirname(__FILE__) + '/db/models'

# configure the TestCase settings
class SemanticAttributes::TestCase < ActiveSupport::TestCase
  include ActiveRecord::TestFixtures
  include PluginTestModels

  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  self.fixture_path = File.dirname(__FILE__) + '/fixtures/'

  fixtures :all
end

class ActiveRecord::Base
  # Aids the management of per-test semantics.
  #
  # Examples:
  #
  # User.stub_semantics_with(:email => :email)
  # User.stub_semantics_with(:email => [:email, :unique])
  # User.stub_semantics_with(:email => {:length => {:above => 5}})
  # User.stub_semantics_with(:email => [:email, {:length => {:above => 5}}])
  def self.stub_semantics_with(attr_predicates = {})
    semantics = SemanticAttributes::Set.new
    attr_predicates.each do |attr, predicates|
      [predicates].flatten.each do |predicate|
        case predicate
          when String, Symbol
          semantics[attr].add(predicate)
          when Hash
          semantics[attr].add(predicate.keys.first, predicate.values.first)
          else
          raise '???'
        end
      end
    end

    self.stubs(:semantic_attributes).returns(semantics)
  end
end
