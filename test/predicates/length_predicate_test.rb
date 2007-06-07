require File.dirname(__FILE__) + '/../test_helper'

class LengthPredicateTest < Test::Unit::TestCase
  def setup
    @predicate = Predicates::Length.new
  end

  def test_range
    @predicate.range = 1..5
    assert !@predicate.validate('', nil)
    assert @predicate.validate('1', nil)
    assert @predicate.validate('12345', nil)
    assert !@predicate.validate('123456', nil)

    @predicate.range = 1...5
    assert !@predicate.validate('12345', nil)
  end

  def test_min
    @predicate.above = 5
    assert !@predicate.validate('', nil)
    assert !@predicate.validate('12345', nil)
    assert @predicate.validate('123456', nil)
  end

  def test_max
    @predicate.below = 5
    assert @predicate.validate('', nil)
    assert @predicate.validate('1234', nil)
    assert !@predicate.validate('12345', nil)
  end

  def test_exact
    @predicate.exactly = 5
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
end