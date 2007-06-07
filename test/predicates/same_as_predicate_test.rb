require File.dirname(__FILE__) + '/../test_helper'

class SameAsPredicateTest < Test::Unit::TestCase
  def setup
    @predicate = Predicates::SameAs.new
  end

  def test_validation
    @predicate.method = :foo

    klass = Struct.new('SomeModel', :foo)
    record = klass.new
    record.foo = 'bar'

    assert @predicate.validate('bar', record)
    assert !@predicate.validate(nil, record)
    assert !@predicate.validate(5, record)
  end
end