require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class UsaStatePredicateTest < Test::Unit::TestCase
  def setup
    @predicate = Predicates::UsaState.new(:foo)
  end

  def test_fixed_options
    assert_raise NoMethodError do @predicate.options = {} end
  end

  def test_with_territories
    @predicate.with_territories = true
    assert_equal 'must be a US state or territory.', @predicate.error_message

    assert @predicate.options.include?('Guam')
    assert @predicate.options.include?('Minnesota')
  end

  def test_without_territories
    @predicate.with_territories = false
    assert_equal 'must be a US state.', @predicate.error_message

    assert !@predicate.options.include?('Guam')
    assert @predicate.options.include?('Minnesota')
  end

  def test_defaults
    assert !@predicate.with_territories?
  end
end
