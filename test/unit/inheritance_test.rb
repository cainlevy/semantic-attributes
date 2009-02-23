require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class InheritanceTest < SemanticAttributes::TestCase
  class Worker < User
    attr_accessor :name_tag
    name_tag_is_required
  end

  class Clerk < Worker
    attr_accessor :pen
    pen_is_required
  end

  def test_parent_semantics
    assert Worker.semantic_attributes[:name_tag].has?(:required)
    assert !Worker.semantic_attributes[:pen].has?(:required)
  end

  def test_child_semantics
    assert Clerk.semantic_attributes[:name_tag].has?(:required)
    assert Clerk.semantic_attributes[:pen].has?(:required)
  end
end
