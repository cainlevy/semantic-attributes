require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class NumberPredicateTest < SemanticAttributes::TestCase
  def setup
    @predicate = Predicates::Number.new(:foo)
  end

  def test_basic_error_message
    assert_equal :not_a_number, @predicate.error_message
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
    assert_equal :greater_than, @predicate.error_message

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
    @predicate.at_least = 5
    assert_equal 5, @predicate.above
    assert @predicate.inclusive
    assert_equal :greater_than_or_equal_to, @predicate.error_message

    assert !@predicate.validate(4, nil)
    assert @predicate.validate(5, nil)
  end

  def test_max
    @predicate.below = 5
    assert_equal :less_than, @predicate.error_message

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
    @predicate.no_more_than = 5
    assert_equal 5, @predicate.below
    assert @predicate.inclusive
    assert_equal :less_than_or_equal_to, @predicate.error_message

    assert @predicate.validate(5, nil)
    assert !@predicate.validate(6, nil)
  end

  def test_range
    @predicate.range = -5...5
    assert_equal :between, @predicate.error_message

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
    assert_equal :between, @predicate.error_message

    assert @predicate.validate(5, nil)
    assert !@predicate.validate(6, nil)
  end
end
