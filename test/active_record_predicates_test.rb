require File.dirname(__FILE__) + '/test_helper'

class ActiveRecordExtensionsTest < Test::Unit::TestCase
  def test_module
    assert ActiveRecord::Base.included_modules.include?(ActiveRecord::Predicates)
    assert ActiveRecord::Base.semantic_attributes.is_a?(SemanticAttributes)
  end

  def test_method_missing
    @klass = FakeModel.dup

    assert_nothing_raised 'creating predicates via method_missing sugar' do
      @klass.foo_is_required
      @klass.bar_has_a_length
      @klass.fax_is_a_phone_number
    end

    assert @klass.semantic_attributes[:foo].has?(:required)
    assert_equal true, @klass.foo_is_required?

    assert @klass.semantic_attributes[:bar].has?(:length)
    assert_equal true, @klass.bar_has_length?

    assert @klass.semantic_attributes[:fax].has?(:phone_number)
    assert_equal true, @klass.fax_is_a_phone_number?
  end

  def test_method_missing_still_works
    assert_raise NoMethodError do FakeModel.i_do_not_exist end
  end
end