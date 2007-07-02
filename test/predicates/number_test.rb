require File.dirname(__FILE__) + '/../test_helper'

class NumberPredicateTest < Test::Unit::TestCase
  def setup
    @predicate = Predicates::Number.new(:foo)
  end

  def test_integers
    @predicate.integer = true

    assert @predicate.validate(0, nil)
    assert @predicate.validate(-15, nil)
    assert @predicate.validate(15, nil)
    assert @predicate.validate('0', nil)
    assert @predicate.validate('-15', nil)
    assert @predicate.validate('+15', nil)

    assert !@predicate.validate('1.0', nil)
    assert !@predicate.validate(1.0, nil)
  end

  def test_floats
    assert !@predicate.integer
    assert @predicate.validate(5, nil), 'still allows integers'
    assert @predicate.validate(-5, nil)
    assert @predicate.validate(5.2, nil)
    assert @predicate.validate(-5.2, nil)
    assert @predicate.validate(0.0, nil)
    assert @predicate.validate(5.2e5, nil)
    assert @predicate.validate(5.2e-5, nil)
  end

  def test_error_message
    assert_equal ' must be a number.', @predicate.error_message
    @predicate.error_message = 'foo'
    assert_equal 'foo', @predicate.error_message
  end
end