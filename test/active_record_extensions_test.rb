require File.dirname(__FILE__) + '/test_helper'

module Annotations
  class Required < Base
  end
  class Email < Base
  end
  class Length < Base
  end
end

class FakeModel < ActiveRecord::Base
  abstract_class = true
end

class ActiveRecordExtensionsTest < Test::Unit::TestCase
  def test_module
    assert ActiveRecord::Base.included_modules.include?(ActiveRecord::Annotations)
    assert ActiveRecord::Base.annotations.is_a?(AnnotationSet)
  end

  def test_method_missing
    assert_nothing_raised {
      FakeModel.foo_is_required
      FakeModel.bar_has_a_length
      FakeModel.hello_world_is_an_email
    }

    assert FakeModel.annotations[:foo].has?(:required)
    assert FakeModel.foo_is_required?

    assert FakeModel.annotations[:bar].has?(:length)
    assert FakeModel.bar_has_length?

    assert FakeModel.annotations[:hello_world].has?(:email)
    assert FakeModel.hello_world_is_an_email?
  end
end