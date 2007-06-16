require File.dirname(__FILE__) + '/test_helper'

class BasePredicateTest < Test::Unit::TestCase
  def setup
    @predicate = Predicates::Base.new(:foo)
  end

  def test_unimplemented_methods
    assert_equal 2, @predicate.method(:validate).arity
    assert_raise NotImplementedError do @predicate.validate(nil, nil) end
    assert_raise NotImplementedError do @predicate.to_human('foo') end
    assert_raise NotImplementedError do @predicate.from_human('foo') end
  end

  def test_initializer_assignment
    predicate = Predicates::Base.new(:foo, :error_message => 'hello world')
    assert_equal 'hello world', predicate.error_message
  end
end