require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class UsaZipCodePredicateTest < SemanticAttributes::TestCase
  def setup
    @predicate = Predicates::UsaZipCode.new(:foo)
  end

  def test_fixed_pattern
    assert_raise NoMethodError do @predicate.like = nil end
  end

  def test_extended_allowed
    @predicate.extended = :allowed

    assert @predicate.validate(12345, nil)
    assert @predicate.validate('12345', nil)
    assert @predicate.validate('12345-4321', nil)
    assert !@predicate.validate('12345-4', nil)
  end

  def test_extended_required
    @predicate.extended = :required

    assert !@predicate.validate(12345, nil)
    assert !@predicate.validate('12345', nil)
    assert @predicate.validate('12345-4321', nil)
    assert !@predicate.validate('12345-4', nil)
  end

  def test_non_extended
    @predicate.extended = false

    assert @predicate.validate(12345, nil)
    assert @predicate.validate('12345', nil)
    assert !@predicate.validate('12345-4321', nil)
    assert !@predicate.validate('12345-4', nil)
  end

  def test_defaults
    assert !@predicate.extended
  end
end
