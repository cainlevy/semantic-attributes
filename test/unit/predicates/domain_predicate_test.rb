require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class DomainPredicateTest < Test::Unit::TestCase
  def setup
    @predicate = Predicates::Domain.new(:foo)
  end

  def test_error_message
    assert_equal 'must be a simple domain.', @predicate.error_message
    @predicate.error_message = 'foo'
    assert_equal 'foo', @predicate.error_message
  end

  def test_valid_domains
    %w(example.com www.example.com).each do |domain|
      assert @predicate.validate(domain, nil), "#{domain} is a valid domain"
    end
  end

  def test_invalid_domains
    %w(example example.com/foo http://example.com 123.45.6.78).each do |domain|
      assert !@predicate.validate(domain, nil), "#{domain} is not a valid domain"
    end
  end

  def test_from_human
    assert_equal "example.com", @predicate.from_human("http://example.com:8080/foo")
    assert_equal "example.com", @predicate.from_human("example.com/foo")
    assert_equal nil, @predicate.from_human(nil)
    assert_equal "", @predicate.from_human("")
    assert_equal "example.com", @predicate.from_human("example.com")
  end
end