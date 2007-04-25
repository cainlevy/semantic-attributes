require File.dirname(__FILE__) + '/test_helper'

class ActiveRecordExtensionsTest < Test::Unit::TestCase
  def test_module
    assert ActiveRecord::Base.included_modules.include?(ActiveRecord::Predicates)
    assert ActiveRecord::Base.semantic_attributes.is_a?(SemanticAttributes)
  end

  def test_method_missing
    assert_nothing_raised 'creating predicates via method_missing sugar' do
      FakeModel.foo_is_required
      FakeModel.bar_has_a_length
      FakeModel.hello_world_is_an_email
      FakeModel.fax_is_a_phone_number
    end

    assert FakeModel.semantic_attributes[:foo].has?(:required)
    assert FakeModel.foo_is_required?

    assert FakeModel.semantic_attributes[:bar].has?(:length)
    assert FakeModel.bar_has_length?

    assert FakeModel.semantic_attributes[:hello_world].has?(:email)
    assert FakeModel.hello_world_is_an_email?

    assert FakeModel.semantic_attributes[:fax].has?(:phone_number)
    assert FakeModel.fax_is_a_phone_number?
  end
end