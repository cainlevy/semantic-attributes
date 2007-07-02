require File.dirname(__FILE__) + '/test_helper'

class ValidationsTest < Test::Unit::TestCase
  def setup
    @record = FakeModel.new
    @record.semantic_attributes.instance_variable_set('@set', []) # todo: this attempts to cleanup ... is there a better way to setup? singletons or something?
    @record.class.module_eval do
      attr_accessor :foo
      foo_is_required
    end
  end

  def test_validation_hook
    class << @record
      def validate_predicates
        raise 'hello world'
      end
    end

    assert_equal 'hello world', (@record.valid? rescue $!.to_s)
  end

  def test_validation_errors
    @record.class.module_eval do
      # we'll tell the localization to just put the string in square brackets
      def _(s); "[#{s}]"; end
    end

    assert(@record.class.foo_is_required? && @record.foo.nil?, 'foo is required and nil')
    assert(!@record.valid?, 'validation fails')
    assert_equal('[ is required.]', @record.errors[:foo], 'error message is registered; also, localization worked')
  end

  def test_validate_if_symbol
    @record.class.module_eval do
      def return_true; true end
      def return_false; false end
    end

    assert_nothing_raised do
      @record.semantic_attributes['foo'].get('required').validate_if = :return_true
    end
    assert !@record.valid?

    assert_nothing_raised do
      @record.semantic_attributes['foo'].get('required').validate_if = :return_false
      @record.semantic_attributes['foo'].get('required').error_message = 'fooooo'
    end
    assert @record.valid?
  end

  def test_validate_if_proc
    assert_nothing_raised do
      @record.semantic_attributes['foo'].get('required').validate_if = proc {true}
    end
    assert !@record.valid?

    assert_nothing_raised do
      @record.semantic_attributes['foo'].get('required').validate_if = proc {false}
    end
    assert @record.valid?
  end

  def test_validate_on
    assert_equal :both, @record.semantic_attributes['foo'].get('required').validate_on, 'validate_on :both by default'

    @record.instance_variable_set('@new_record', true)
    assert !@record.valid?
    assert_nothing_raised do
      @record.semantic_attributes['foo'].get('required').validate_on = :update
    end
    assert @record.valid?, 'validation skipped when validate_on :update and new_record?'

    @record.instance_variable_set('@new_record', false)
    assert !@record.valid?
    assert_nothing_raised do
      @record.semantic_attributes['foo'].get('required').validate_on = :create
    end
    assert @record.valid?, 'validation skipped when validate_on :create and !new_record?'
  end
end