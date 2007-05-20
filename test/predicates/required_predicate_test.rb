require File.dirname(__FILE__) + '/../test_helper'

class RequiredPredicateTest < Test::Unit::TestCase
  def setup
    @predicate = Predicates::Required.new
  end

  def test_simple_objects
    assert !@predicate.validate(nil, nil), 'nil does not satisfy required'

    assert !@predicate.validate('', nil), 'empty string does not satisfy required'
    assert @predicate.validate('foo', nil)

    assert !@predicate.validate([], nil), 'empty array does not satisfy required'
    assert @predicate.validate([1, 2, 3], nil)

    assert @predicate.validate(0, nil)
    assert @predicate.validate(10, nil)

    assert !@predicate.validate({}, nil), 'empty hash does not satisfy required'
    assert @predicate.validate({1 => 2}, nil)

    assert @predicate.validate(:foo, nil)
  end

  def test_associations
    assert false
  end
end