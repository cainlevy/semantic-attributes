require File.dirname(__FILE__) + '/../test_helper'

class LengthPredicateTest < Test::Unit::TestCase
  def setup
    @predicate = Predicates::Length.new(:foo)
  end

  def test_range
    @predicate.range = 1..5
    assert_equal '%s must be 1 to 5 characters long.', @predicate.error_message

    assert !@predicate.validate('', nil)
    assert @predicate.validate('1', nil)
    assert @predicate.validate('12345', nil)
    assert !@predicate.validate('123456', nil)

    @predicate.range = 1...5
    assert_equal '%s must be 1 to 5 characters long.', @predicate.error_message, 'same message for inclusive range'
    assert !@predicate.validate('12345', nil)
  end

  def test_min
    @predicate.above = 5
    assert_equal '%s must be more than 5 characters long.', @predicate.error_message

    assert !@predicate.validate('', nil)
    assert !@predicate.validate('12345', nil)
    assert @predicate.validate('123456', nil)
  end

  def test_max
    @predicate.below = 5
    assert_equal '%s must be less than 5 characters long.', @predicate.error_message

    assert @predicate.validate('', nil)
    assert @predicate.validate('1234', nil)
    assert !@predicate.validate('12345', nil)
  end

  def test_exact
    @predicate.exactly = 5
    assert_equal '%s must be 5 characters long.', @predicate.error_message

    assert !@predicate.validate('', nil)
    assert !@predicate.validate('1234', nil)
    assert @predicate.validate('12345', nil)
    assert !@predicate.validate('123456', nil)
  end

  def test_data_types
    @predicate.range = 1..5
    assert @predicate.validate(:abc, nil)
    assert @predicate.validate(6, nil), 'length converts to a string'
    assert @predicate.validate(0, nil), 'length converts to a string'
  end

  def test_no_options
    assert_raise RuntimeError do @predicate.error_message end
    assert @predicate.validate(nil, nil)
  end
end