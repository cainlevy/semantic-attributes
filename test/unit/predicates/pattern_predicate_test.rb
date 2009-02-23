require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class PatternPredicateTest < SemanticAttributes::TestCase
  def setup
    @predicate = Predicates::Pattern.new(:foo)
  end

  def test_regexp_pattern
    @predicate.like = /bar$/

    assert @predicate.validate('foobar', nil)
    assert @predicate.validate(:foobar, nil)
    assert !@predicate.validate('foobario', nil)
  end

  def test_string_pattern
    @predicate.like = 'bar'

    assert @predicate.validate('foobar', nil)
    assert @predicate.validate(:bar, nil)
  end

  def test_line_breaks
    @predicate.like = /^hello world$/
    assert @predicate.validate("malicious\nhello world\ntext", nil)
    @predicate.like = /\Ahello world\Z/
    assert !@predicate.validate("malicious\nhello world\ntext", nil)
  end
end