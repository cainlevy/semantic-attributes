require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class ActiveRecordExtensionsTest < Test::Unit::TestCase
  def test_module
    assert ActiveRecord::Base.included_modules.include?(SemanticAttributes::Predicates)
    assert ActiveRecord::Base.semantic_attributes.is_a?(SemanticAttributes::Set)
  end

  def test_method_missing
    @klass = User.dup
    @klass.class_eval do
      attr_reader :foo, :bar, :fax
    end

    assert_nothing_raised 'creating predicates via method_missing sugar' do
      @klass.foo_is_required
      @klass.bar_has_a_length
      @klass.fax_is_a_phone_number
    end
    
    assert_raises ArgumentError do
      @klass.unknown_is_required
    end

    assert @klass.semantic_attributes[:foo].has?(:required)
    assert @klass.foo_is_required?

    assert @klass.semantic_attributes[:bar].has?(:length)
    assert @klass.bar_has_length?

    assert @klass.semantic_attributes[:fax].has?(:phone_number)
    assert @klass.fax_is_a_phone_number?
  end

  def test_method_missing_still_works
    assert_raise NoMethodError do User.i_do_not_exist end
  end

  ##
  ## Want to test :expected_error_for with some common predicates.
  ##

  class PasswordUser < PluginTestModels::User
    attr_accessor :password, :password_confirmation
  end

  def test_expected_error_for_with_unique_predicate
    PasswordUser.stub_semantics_with(:login => :unique)
    assert_not_nil PasswordUser.expected_error_for(:login, users(:bob).login)
    assert_nil PasswordUser.expected_error_for(:login, "veryuniquelogin!")
  end

  def test_expected_error_for_with_length_predicate
    PasswordUser.stub_semantics_with(:login => {:length => {:above => 5}})
    assert_not_nil PasswordUser.expected_error_for(:login, "a" * 4)
    assert_nil PasswordUser.expected_error_for(:login, "a" * 6)
  end

  def test_expected_error_for_with_same_as_predicate
    PasswordUser.stub_semantics_with(:password_confirmation => {:same_as => {:method => :password}})
    assert_not_nil PasswordUser.expected_error_for(:password_confirmation, "one thing", :password => "another thing")
    assert_nil PasswordUser.expected_error_for(:password_confirmation, "thing", :password => "thing")
  end
end
