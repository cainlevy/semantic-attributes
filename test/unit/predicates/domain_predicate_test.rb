require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class DomainPredicateTest < SemanticAttributes::TestCase
  def setup
    @predicate = Predicates::Domain.new(:foo)
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

  def test_normalize
    assert_equal "example.com", @predicate.normalize("http://example.com:8080/foo")
    assert_equal "example.com", @predicate.normalize("example.com/foo")
    assert_equal nil, @predicate.normalize(nil)
    assert_equal "", @predicate.normalize("")
    assert_equal "example.com", @predicate.normalize("example.com")
  end
end
