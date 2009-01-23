require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class AttributeFormatsTest < Test::Unit::TestCase
  class User < User
    cell_is_a_phone_number
  end

  def setup
    @record = User.new
  end

  def test_semantic_attribute_read_and_write
    assert_nothing_raised do
      @record.cell = '(222) 333.4444'
    end
    assert_equal '+12223334444', @record.attributes['cell'], 'value is stored in normalized format'

    assert_equal '+12223334444', @record.cell, 'read defaults to machine format'
    assert @record.respond_to?(:cell_for_human)
    assert_equal '(222) 333-4444', @record.cell_for_human, 'reading in human format'
  end

  def test_regular_attribute_read_and_write
    assert_nothing_raised do
      @record.login = 'hugo'
    end
    assert_equal 'hugo', @record.attributes['login']
    assert !@record.respond_to?(:login_for_human)
    assert_raise NoMethodError do @record.login_for_human end
  end

  def test_normalize
    assert_equal '+12223334444', User.normalize(:cell, '(222) 333.4444')
  end

  def test_humanize
    assert_equal '(222) 333-4444', User.humanize(:cell, '+12223334444')
  end
end
