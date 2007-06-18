require File.dirname(__FILE__) + '/test_helper'

class AttributeFormatsTest < Test::Unit::TestCase
  def setup
    FakeModel.semantic_attributes.instance_variable_set('@set', []) # todo: this attempts to cleanup ... is there a better way to setup? singletons or something?
    FakeModel.semantic_attributes[:foo].add('phone_number')
    
    @record = FakeModel.new
    @record.send(:instance_variable_set, '@attributes', {'foo' => nil, 'bar' => nil})
  end
  
  def test_semantic_attribute_read_and_write
    assert_nothing_raised do
      @record.foo = '(222) 333.4444'
    end
    assert_equal '+12223334444', @record.attributes['foo'], 'machinized write'
    
    assert_equal '+12223334444', @record.foo, 'read defaults to machine format'
    assert @record.respond_to?(:foo_for_human)
    assert_equal '(222) 333-4444', @record.foo_for_human, 'reading in human format'
  end
  
  def test_regular_attribute_read_and_write
    assert_nothing_raised do
      @record.bar = 'world'
    end
    assert_equal 'world', @record.attributes['bar']
    assert !@record.respond_to?(:bar_for_human)
    assert_raise NoMethodError do @record.bar_for_human end
  end
  
  def test_machinize
    assert_equal '+12223334444', FakeModel.machinize(:foo, '(222) 333.4444')
  end
  
  def test_humanize
    assert_equal '(222) 333-4444', FakeModel.humanize(:foo, '+12223334444')
  end
end