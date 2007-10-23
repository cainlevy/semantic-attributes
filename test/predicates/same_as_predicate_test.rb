require File.dirname(__FILE__) + '/../test_helper'

class SameAsPredicateTest < Test::Unit::TestCase
  def setup
    @predicate = Predicates::SameAs.new(:foo)
  end

  def test_validation
    @predicate.method = :bar

    klass = Struct.new('SomeModel', :bar)
    record = klass.new
    record.bar = 'something'

    assert @predicate.validate('something', record)
    assert !@predicate.validate(nil, record)
    assert !@predicate.validate(5, record)
  end
end