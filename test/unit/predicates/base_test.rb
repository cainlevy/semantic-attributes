require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class BasePredicateTest < SemanticAttributes::TestCase
  def setup
    @predicate = Predicates::Base.new(:foo)
  end

  def test_unimplemented_methods
    assert_equal 2, @predicate.method(:validate).arity
    assert_raise NotImplementedError do @predicate.validate(nil, nil) end
    assert_equal 'foo', @predicate.to_human('foo')
    assert_equal 'foo', @predicate.normalize('foo')
  end

  def test_initializer_assignment
    predicate = Predicates::Base.new(:foo, :error_message => 'hello world')
    assert_equal 'hello world', predicate.error_message
  end

  def test_initializer_assignment_with_typos
    assert_raises NoMethodError do
      Predicates::Base.new(:foo, :unknown_option => "something")
    end
  end
  
  def test_default_values
    assert @predicate.allow_empty?, "allow empty/nil values by default"
    assert_equal :both, @predicate.validate_on, "validate on create and update by default"
    assert_equal :invalid, @predicate.error_message, "error message is a bland :invalid by default"
    assert_equal Hash.new, @predicate.error_binds, "there are no binds by default"
  end

  def test_or_empty
    predicate = Predicates::Base.new(:foo, :or_empty => true)
    assert predicate.allow_empty?
    predicate = Predicates::Base.new(:foo, :or_empty => false)
    assert !predicate.allow_empty?
  end
  
  def test_message_aliasing
    predicate = Predicates::Base.new(:foo)
    predicate.error_message = "something"
    assert_equal "something", predicate.message
    predicate.message = "another thing"
    assert_equal "another thing", predicate.error_message
  end
end
