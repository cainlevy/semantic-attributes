require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class HexColorPredicateTest < Test::Unit::TestCase
  def setup
    @predicate = Predicates::HexColor.new(:foo)
  end

  def test_default_error_message
    assert_equal @predicate.error_message, "must be a hex color."
  end

  def test_from_human_conversions
    assert_equal "#123456", @predicate.from_human("123456"), "adds a pound sign"
    assert_equal "#123456", @predicate.from_human("#123456"), "does not duplicate the pound sign"
    assert_equal "#112233", @predicate.from_human("123"), "expand three-character syntax"
    assert_equal "#112233", @predicate.from_human("#123"), "handles existing pound sign when expanding to six characters"
  end

  def test_valid_colors
    %w(#123456 #fff000).each do |color|
      assert @predicate.validate(color, nil), "#{color} should be a valid hex color"
    end
  end

  def test_invalid_colors
    %w(1 12 123 1234 12345 abc zzz kf0f00).each do |color|
      assert !@predicate.validate(color, nil), "#{color} should be a invalid hex color"
    end
  end

end