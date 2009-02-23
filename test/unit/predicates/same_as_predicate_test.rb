require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class SameAsPredicateTest < SemanticAttributes::TestCase
  def setup
    @predicate = Predicates::SameAs.new(:foo)
  end

  def test_validation
    @predicate.method = :bar

    record = mock()
    record.stubs(:bar).returns("something")

    assert @predicate.validate('something', record)
    assert !@predicate.validate('something else', record)
    assert !@predicate.validate(nil, record)
    assert !@predicate.validate(5, record)
  end
end