require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class RequiredPredicateTest < Test::Unit::TestCase
  def setup
    @predicate = Predicates::Required.new(:foo)
  end

  def test_allow_empty
    assert !@predicate.allow_empty?
    @predicate.or_empty = false
    assert !@predicate.allow_empty?
  end
end