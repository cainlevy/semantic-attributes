require File.dirname(__FILE__) + '/test_helper'

class SemanticAttributesTest < Test::Unit::TestCase
  def setup
    @set = SemanticAttributes.new
  end

  def test_add
    assert @set.instance_variable_get('@set').empty?
    assert_raises ArgumentError, "can't add by symbol" do @set.add :foo end
    assert @set.instance_variable_get('@set').empty?
    assert_nothing_raised "can add a SemanticAttribute instance" do @set.add SemanticAttribute.new(:foo) end
    assert @set.instance_variable_get('@set').size == 1
  end

  def test_find
    assert !@set.include?(:a)
  
    # test retrieving a previously set field
    a = SemanticAttribute.new(:a)
    @set.add a
    assert @set.include?(:a)
    assert_equal a, @set[:a], 'can find previously set fields'

    # test creating a field by requesting it
    assert @set[:b].is_a?(SemanticAttribute), 'can create a SemanticAttribute by requesting it from the set'
  end
end
