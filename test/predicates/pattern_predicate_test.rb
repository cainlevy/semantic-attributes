require File.dirname(__FILE__) + '/../test_helper'

class PatternPredicateTest < Test::Unit::TestCase
  def setup
    @predicate = Predicates::Pattern.new
  end

  def test_regexp_pattern
    @predicate.like = /bar$/

    assert @predicate.validate('foobar', nil)
    assert @predicate.validate(:foobar, nil)
    assert !@predicate.validate('foobario', nil)
  end

  def test_string_pattern
    @predicate.like = 'bar'

    assert @predicate.validate('foobar', nil)
    assert @predicate.validate(:bar, nil)
  end
end