require File.dirname(__FILE__) + '/test_helper'

class BasePredicateTest < Test::Unit::TestCase
  def setup
    @predicate = Predicates::Base.new(:foo)
  end

  def test_attribute
    assert_equal :foo, @predicate.attribute
  end

  def test_unimplemented_methods
    assert_raise NotImplementedError do @predicate.validation end
    assert_raise NotImplementedError do @predicate.to_human('foo') end
    assert_raise NotImplementedError do @predicate.from_human('foo') end
  end

  def test_initializer_assignment
    predicate = Predicates::Base.new(:bar, :error_message => 'hello world')
    assert_equal 'hello world', predicate.error_message
  end

  def test_validate_if_assignment
    assert_nothing_raised do
      @predicate.validate_if = :model_method_passes
    end

    assert_nothing_raised do
      @predicate.validate_if = proc {|record| true}
    end
  end

  def test_validate_on_assignment
    assert_nothing_raised do
      [:both, :create, :update].each {|val| @predicate.validate_on = val}
    end
  end
end