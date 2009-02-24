require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class LengthPredicateTest < SemanticAttributes::TestCase
  def setup
    @predicate = Predicates::Length.new(:foo)
  end

  def test_range
    @predicate.range = 1..5
    assert_equal :wrong_length, @predicate.error_message

    assert !@predicate.validate('', nil)
    assert @predicate.validate('1', nil)
    assert @predicate.validate('12345', nil)
    assert !@predicate.validate('123456', nil)

    @predicate.range = 1...5
    assert_equal :wrong_length, @predicate.error_message, 'same message for inclusive range'
    assert !@predicate.validate('12345', nil)
  end

  def test_min
    @predicate.above = 5
    assert_equal :too_short, @predicate.error_message

    assert !@predicate.validate('', nil)
    assert !@predicate.validate('12345', nil)
    assert @predicate.validate('123456', nil)
  end

  def test_max
    @predicate.below = 5
    assert_equal :too_long, @predicate.error_message

    assert @predicate.validate('', nil)
    assert @predicate.validate('1234', nil)
    assert !@predicate.validate('12345', nil)
  end

  def test_exact
    @predicate.exactly = 5
    assert_equal :inexact_length, @predicate.error_message

    assert !@predicate.validate('', nil)
    assert !@predicate.validate('1234', nil)
    assert @predicate.validate('12345', nil)
    assert !@predicate.validate('123456', nil)
  end
  
  def test_symbols
    @predicate.range = 2..3
    assert @predicate.validate(:abc, nil)
    assert !@predicate.validate(:abcdef, nil)
  end
  
  def test_numbers
    @predicate.range = 2..3
    assert !@predicate.validate(3, nil)
    assert @predicate.validate(123, nil)
  end
  
  def test_arrays
    @predicate.range = 2..3
    assert !@predicate.validate(['abc'], nil)
    assert @predicate.validate(['abc', 'def', 'ghi'], nil)
  end
  
  def test_multibyte_characters
    $KCODE = "UTF8" # so ActiveSupport uses the UTF8Handler for Chars
    @predicate.exactly = 4
    assert @predicate.validate('ægis', nil)
    assert !@predicate.validate('aegis', nil)
  end

  def test_no_options
    assert_raise RuntimeError do @predicate.error_message end
    assert @predicate.validate(nil, nil)
  end
end
