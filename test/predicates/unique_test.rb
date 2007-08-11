require File.dirname(__FILE__) + '/../test_helper'

class UniquePredicateTest < Test::Unit::TestCase
  class UniqueTestModel < FakeModel
    set_table_name 'table'

    attr_accessor :a # for scope testing
    attr_accessor :foo # unique attribute
    cattr_accessor :last_conditions
    cattr_accessor :finder_return

    def self.find(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      self.last_conditions = options[:conditions]
      return self.finder_return || []
    end
  end

  def setup
    @record = UniqueTestModel.new
    @record.a = 'A'
    @predicate = Predicates::Unique.new(:foo)
  end

  def test_defaults
    assert_equal true, @predicate.case_sensitive, 'case sensitive by default'
    assert_equal [], @predicate.scope, 'default scope is empty array'
    assert_equal "has already been taken.", @predicate.error_message
  end

  def test_conditions_generation
    @predicate.validate('bar', @record)
    assert_equal ['table.foo = ?', 'bar'], @record.last_conditions, 'can handle string datatype'

    @predicate.validate(nil, @record)
    assert_equal ['table.foo IS ?', nil], @record.last_conditions, 'can handle nil datatype, and presumably all the other standard types'

    # add in scope
    @predicate.scope = [:a]
    @predicate.validate('bar', @record)
    last_conditions = @record.last_conditions
    assert_equal ['table.foo = ? AND table.a = ?', 'bar', 'A'], @record.last_conditions, 'can handle scope'

    # make it all case insensitive
    @predicate.case_sensitive = false
    @predicate.validate('bar', @record)
    assert_equal ['LOWER(table.foo) = ? AND LOWER(table.a) = ?', 'bar', 'a'], @record.last_conditions, 'can handle case insensitive uniqueness'
  end

  def test_uniqueness_check
    @record.finder_return = []
    assert @predicate.validate('bar', @record), 'valid when return is empty'

    @record.finder_return = ['a', 'b']
    assert !@predicate.validate('bar', @record), 'not unique with more than one return'

    @record.finder_return = ['a']
    assert !@predicate.validate('bar', @record), 'not unique when only return is different than @record'

    @same_record = @record.class.new
    @record.id = @same_record.id = '52'
    @record.instance_variable_set('@new_record', false)
    @record.finder_return = [@same_record]
    assert @predicate.validate('bar', @record), 'valid when only return is same as @record (and @record is not new)'
  end
end