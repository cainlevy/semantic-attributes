require File.dirname(__FILE__) + '/test_helper'

module Predicates
  class FakePredicate < Base
  end
end

class SemanticAttributeTest < Test::Unit::TestCase
  def test_everything
    @field = SemanticAttribute.new(:a)
    # i'm sneakily adding something that shouldn't even be a possible predicate. actually i should be testing that this *doesn't* add. :)
    @field.add 'fake_predicate'

    assert_equal :a, @field.field
    assert @field.has?('fake_predicate')
    assert @field.get('fake_predicate').is_a?(Predicates::FakePredicate)
  end
end