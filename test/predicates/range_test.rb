require File.dirname(__FILE__) + '/../test_helper'

class RangePredicateTest < Test::Unit::TestCase
  def setup
    @predicate = Predicates::Range.new(:foo)
  end

  def test_min
    @predicate.above = 5
    assert_equal '%s must be more than 5.', @predicate.error_message

    assert !@predicate.validate(-10, nil)
    assert !@predicate.validate(-5, nil)
    assert !@predicate.validate(0, nil)
    assert !@predicate.validate(5, nil)
    assert @predicate.validate(10, nil)

    assert @predicate.validate(5.0001, nil)
    @predicate.integer = true
    assert !@predicate.validate(5.0001, nil)
  end

  def test_min_inclusive
    @predicate.above = 5
    @predicate.inclusive = true
    assert_equal '%s must be at least 5.', @predicate.error_message

    assert !@predicate.validate(4, nil)
    assert @predicate.validate(5, nil)
  end

  def test_max
    @predicate.below = 5
    assert_equal '%s must be less than 5.', @predicate.error_message

    assert @predicate.validate(-10, nil)
    assert @predicate.validate(-5, nil)
    assert @predicate.validate(0, nil)
    assert !@predicate.validate(5, nil)
    assert !@predicate.validate(10, nil)

    assert @predicate.validate(4.9999, nil)
    @predicate.integer = true
    assert !@predicate.validate(4.9999, nil)
  end

  def test_max_inclusive
    @predicate.below = 5
    @predicate.inclusive = true
    assert_equal '%s must be no more than 5.', @predicate.error_message

    assert @predicate.validate(5, nil)
    assert !@predicate.validate(6, nil)
  end

  def test_range
    @predicate.range = -5...5
    assert_equal '%s must be a number from -5 to 5.', @predicate.error_message

    assert !@predicate.validate(-10, nil)
    assert @predicate.validate(-5, nil)
    assert @predicate.validate(0, nil)
    assert !@predicate.validate(5, nil)
    assert !@predicate.validate(10, nil)

    assert @predicate.validate(4.9999, nil)
    @predicate.integer = true
    assert !@predicate.validate(4.9999, nil)
  end

  def test_range_inclusive
    @predicate.range = -5..5
    assert_equal '%s must be a number from -5 through 5.', @predicate.error_message

    assert @predicate.validate(5, nil)
    assert !@predicate.validate(6, nil)
  end

  def test_no_options
    assert_raise RuntimeError do @predicate.error_message end
    assert !@predicate.validate(nil, nil)
  end
end