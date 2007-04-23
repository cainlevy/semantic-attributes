require File.dirname(__FILE__) + '/test_helper'

module Annotations
  class FakeAnnotation < Base
  end
end

class AnnotatedFieldTest < Test::Unit::TestCase
  def test_everything
    @field = AnnotatedField.new(:a)
    # i'm sneakily adding something that shouldn't even be a possible annotation. actually i should be testing that this *doesn't* add. :)
    @field.add 'fake_annotation'

    assert_equal :a, @field.field
    assert @field.has?('fake_annotation')
    assert @field.get('fake_annotation').is_a?(Annotations::FakeAnnotation)
  end
end