require File.dirname(__FILE__) + '/../test_helper'

class RequiredPredicateTest < Test::Unit::TestCase
  class ModelA < FakeModel
    model_b_is_required
    attr_accessor :model_b
  end
  
  class ModelB < FakeModel
    attr_accessor :model_a
  end
  
  def setup
    @predicate = Predicates::Required.new(:foo)
  end

  def test_simple_objects
    assert !@predicate.validate(nil, nil), 'nil does not satisfy required'

    assert !@predicate.validate('', nil), 'empty string does not satisfy required'
    assert @predicate.validate('foo', nil)

    assert !@predicate.validate([], nil), 'empty array does not satisfy required'
    assert @predicate.validate([1, 2, 3], nil)

    assert @predicate.validate(0, nil)
    assert @predicate.validate(10, nil)

    assert !@predicate.validate({}, nil), 'empty hash does not satisfy required'
    assert @predicate.validate({1 => 2}, nil)

    assert @predicate.validate(:foo, nil)
  end

  def test_associations
    @model_a = ModelA.new
    @model_a.model_b = ModelB.new
    
    @model_b = ModelB.new
    @model_b.model_a = ModelA.new
    
    assert !@predicate.validate(nil, @model_a)
    assert @predicate.validate(@model_b, @model_a)
  end
end