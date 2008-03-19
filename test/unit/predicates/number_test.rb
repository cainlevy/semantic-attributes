require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class NumberPredicateTest < Test::Unit::TestCase
  def setup
    @predicate = Predicates::Number.new(:foo)
  end

  def test_basic_error_message
    assert_equal 'must be a number.', @predicate.error_message
    @predicate.error_message = 'foo'
    assert_equal 'foo', @predicate.error_message
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

  def test_min
    @predicate.above = 5
    assert_equal 'must be a number greater than 5.', @predicate.error_message

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
    assert_equal 'must be a number at least 5.', @predicate.error_message

    assert !@predicate.validate(4, nil)
    assert @predicate.validate(5, nil)
  end

  def test_max
    @predicate.below = 5
    assert_equal 'must be a number less than 5.', @predicate.error_message

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
    assert_equal 'must be a number no more than 5.', @predicate.error_message

    assert @predicate.validate(5, nil)
    assert !@predicate.validate(6, nil)
  end

  def test_range
    @predicate.range = -5...5
    assert_equal 'must be a number from -5 to 5.', @predicate.error_message

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
    assert_equal 'must be a number from -5 through 5.', @predicate.error_message

    assert @predicate.validate(5, nil)
    assert !@predicate.validate(6, nil)
  end
end