require File.dirname(__FILE__) + '/test_helper'

class SemanticAttributeTest < Test::Unit::TestCase
  def test_everything
    @field = SemanticAttribute.new('a')
    assert_equal :a, @field.field, 'can read field name back as a symbol'

    assert !@field.has?('required'), 'predicate does not exist prematurely'
    assert_nothing_raised 'can add a predicate using the short name' do @field.add 'required' end
    assert @field.has?('required'), 'predicate exists after adding'
    assert @field.get('required').is_a?(Predicates::Required), 'can get predicate object'
  end

  def test_short_names
    @attribute = SemanticAttribute.new('a')
    assert_equal Predicates::PhoneNumber, @attribute.send(:class_of, 'phone_number')
  end
end