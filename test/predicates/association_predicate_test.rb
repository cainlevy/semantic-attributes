require File.dirname(__FILE__) + '/../test_helper'

class AssociationPredicateTest < Test::Unit::TestCase
  class ModelA < FakeModel
    attr_accessor :model_b
    model_b_is_association
  end

  class ModelB < FakeModel
    attr_accessor :model_a
    model_a_is_association
  end

  def test_singular_associations
    @predicate = Predicates::Association.new(:foo)

    ModelA.semantic_attributes[:model_b].get('association').or_empty = true
    @associated = ModelA.new
    assert @predicate.validate(@associated, nil)
  end

  def test_plural_associations
    @predicate = Predicates::Association.new(:foo)

    ModelA.semantic_attributes[:model_b].get('association').or_empty = true
    @associated = [ModelA.new] * 3
    assert @predicate.validate(@associated, nil)

    @predicate.min = 5
    @predicate.max = nil
    assert !@predicate.validate(@associated, nil), "min works"

    @predicate.min = 2
    @predicate.max = nil
    assert @predicate.validate(@associated, nil), "min doesn't not work"

    # test maxes
    @predicate.min = nil
    @predicate.max = 2
    assert !@predicate.validate(@associated, nil), "max works"

    @predicate.min = nil
    @predicate.max = 5
    assert @predicate.validate(@associated, nil), "max doesn't not work"
  end

  def test_recursion
    @model_a = ModelA.new
    @model_b = ModelB.new

    @model_a.model_b = @model_b
    @model_b.model_a = @model_a

    ModelA.semantic_attributes[:model_b].get('association').or_empty = false
    assert @model_a.new_record?
    ModelB.semantic_attributes[:model_a].get('association').or_empty = false
    assert @model_b.new_record?

    # ok, they're both new and they both depend on each other to be valid. this should blow up without recursion control.
    valid = nil
    assert_nothing_raised {valid = @model_a.valid?}
    assert valid, 'they should both be valid'
  end
end