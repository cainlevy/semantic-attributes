require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class HexColorPredicateTest < SemanticAttributes::TestCase
  def setup
    @predicate = Predicates::HexColor.new(:foo)
  end

  def test_normalize_conversions
    assert_equal "", @predicate.normalize("")
    assert_equal nil, @predicate.normalize(nil)
    assert_equal "#123456", @predicate.normalize("123456"), "adds a pound sign"
    assert_equal "#123456", @predicate.normalize("#123456"), "does not duplicate the pound sign"
    assert_equal "#112233", @predicate.normalize("123"), "expand three-character syntax"
    assert_equal "#112233", @predicate.normalize("#123"), "handles existing pound sign when expanding to six characters"
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
