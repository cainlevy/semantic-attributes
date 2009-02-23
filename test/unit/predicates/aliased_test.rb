require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class AliasedPredicateTest < SemanticAttributes::TestCase
  def setup
    @predicate = Predicates::Aliased.new(:foo, :options => {'10111001' => '185'})
  end

  def test_formats
    assert_equal '185', @predicate.to_human('10111001')
    assert_equal '10111001', @predicate.normalize('185')
  end
end
