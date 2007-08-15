require File.dirname(__FILE__) + '/test_helper'

class InheritanceTest < Test::Unit::TestCase
  class ParentModel < FakeModel
    foo_is_required
  end

  class ChildModel < ParentModel
    bar_is_required
  end

  def test_parent_semantics
    assert ParentModel.semantic_attributes[:foo].has?(:required)
    assert !ParentModel.semantic_attributes[:bar].has?(:required)
  end

  def test_child_semantics
    assert ChildModel.semantic_attributes[:foo].has?(:required)
    assert ChildModel.semantic_attributes[:bar].has?(:required)
  end
end