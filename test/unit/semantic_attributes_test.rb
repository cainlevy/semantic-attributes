require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class SemanticAttributesTest < SemanticAttributes::TestCase
  def setup
    @set = SemanticAttributes::Set.new
  end

  def test_add
    assert @set.instance_variable_get('@set').empty?
    assert_raises ArgumentError, "can't add by symbol" do @set.add :foo end
    assert @set.instance_variable_get('@set').empty?
    assert_nothing_raised "can add a SemanticAttribute instance" do @set.add SemanticAttributes::Attribute.new(:foo) end
    assert @set.instance_variable_get('@set').size == 1
  end

  def test_find
    assert !@set.include?(:a)

    # test retrieving a previously set field
    a = SemanticAttributes::Attribute.new(:a)
    @set.add a
    assert @set.include?(:a)
    assert_equal a, @set[:a], 'can find previously set fields'
  end

  def test_that_find_creates_if_not_found
    assert @set[:a].is_a?(SemanticAttributes::Attribute), 'can create an Attribute by requesting it from the set'
  end
end
