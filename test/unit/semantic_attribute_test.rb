require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class SemanticAttributeTest < SemanticAttributes::TestCase
  def test_everything
    @field = SemanticAttributes::Attribute.new('a')
    assert_equal :a, @field.field

    assert !@field.has?('required')
    assert_nothing_raised do @field.add 'required' end
    assert @field.has?('required')
    assert @field.get('required').is_a?(Predicates::Required)
  end

  def test_short_names
    @attribute = SemanticAttributes::Attribute.new('a')
    assert_equal Predicates::PhoneNumber, @attribute.send(:class_of, 'phone_number')
  end
end
