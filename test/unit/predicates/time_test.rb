require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class TimePredicateTest < Test::Unit::TestCase
  def setup
    @predicate = Predicates::Time.new(:foo)
  end

  def test_error_message
    assert_equal 'must be a point in time.', @predicate.error_message
    @predicate.error_message = 'foo'
    assert_equal 'foo', @predicate.error_message
  end

  def test_default_validation
    assert !@predicate.validate('2007-07-19 00:00:00', nil), 'value may not be a string, even if string parses'
    assert !@predicate.validate(1184817600, nil), 'value must not be a timestamp'
    assert @predicate.validate(Time.parse('2007-07-19 00:00:00'), nil)
  end

  def test_validation_with_before
    @predicate.before = '2007-07-19 00:00:00'
    assert_equal Time.parse('2007-07-19 00:00:00'), @predicate.before

    assert @predicate.validate(Time.parse('2007-07-18 23:59:00'), nil), 'may be earlier'
    assert !@predicate.validate(Time.parse('2007-07-19 00:00:00'), nil), 'may not be equal'
    assert !@predicate.validate(Time.parse('2007-07-19 00:00:01'), nil), 'may not be after'
  end

  def test_validation_with_after
    @predicate.after = '2007-07-19 00:00:00'
    assert_equal Time.parse('2007-07-19 00:00:00'), @predicate.after

    assert !@predicate.validate(Time.parse('2007-07-18 23:59:00'), nil), 'may not be before'
    assert !@predicate.validate(Time.parse('2007-07-19 00:00:00'), nil), 'may not be equal'
    assert @predicate.validate(Time.parse('2007-07-19 00:00:01'), nil), 'may be afterwards'
  end

  def test_validation_with_before_and_after
    @predicate.before = '2007-01-01 00:00:00'
    @predicate.after = '2006-01-01 00:00:00'

    assert !@predicate.validate(Time.parse('2005-01-01 00:00:00'), nil), 'may not be earlier'
    assert @predicate.validate(Time.parse('2006-06-01 00:00:00'), nil), 'may be inbetween'
    assert !@predicate.validate(Time.parse('2008-01-01 00:00:00'), nil), 'may not be after'
  end
  
  def test_validation_with_distance
    @predicate.distance = (-1.hour)..(1.hour)
    assert !@predicate.validate(61.minutes.ago, nil)
    assert @predicate.validate(59.minutes.ago, nil)
    assert @predicate.validate(Time.now, nil)
    assert @predicate.validate(Time.now + 59.minutes, nil)
    assert !@predicate.validate(Time.now + 61.minutes, nil)
  end
end
