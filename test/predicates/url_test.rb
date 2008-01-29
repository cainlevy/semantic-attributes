require File.dirname(__FILE__) + '/../test_helper'

class UrlPredicateTest < Test::Unit::TestCase
  def setup
    @predicate = Predicates::Url.new(:foo)
  end

  def test_ip_addresses
    assert_equal true, @predicate.allow_ip_address, 'default allow_ip_address is true'
    assert @predicate.validate('http://192.168.0.10', nil), 'ip address'
    assert @predicate.validate('http://www.example.com', nil), 'basic url still works'

    @predicate.allow_ip_address = false
    assert !@predicate.validate('http://192.168.0.10', nil), 'ip address'
    assert @predicate.validate('http://www.example.com', nil), 'basic url still works'
  end

  def test_schemes
    assert_equal ['http', 'https'], @predicate.schemes, 'default allowed schemes'

    assert @predicate.validate('http://example.com/', nil)
    assert !@predicate.validate('ftp://example.com/', nil)

    @predicate.schemes = ['ftp']

    assert !@predicate.validate('http://example.com/', nil)
    assert @predicate.validate('ftp://example.com/', nil)
  end

  def test_domains
    assert_equal nil, @predicate.domains, 'default allows any domain'

    assert @predicate.validate('http://example.com', nil)
    assert @predicate.validate('http://example.co.uk', nil)
    assert @predicate.validate('http://example.xyz', nil)
    assert !@predicate.validate('http://example', nil)
    assert !@predicate.validate('http://example.', nil)
    assert @predicate.validate('http://127.0.0.1', nil)

    @predicate.domains = ['com', 'net', 'org']

    assert @predicate.validate('http://example.com', nil)
    assert !@predicate.validate('http://example.co.uk', nil)
    assert !@predicate.validate('http://example.xyz', nil)
    assert !@predicate.validate('http://example', nil)
    assert !@predicate.validate('http://example.', nil)
    assert !@predicate.validate('http://127.0.0.1', nil)
  end

  def test_ports
    assert_equal nil, @predicate.ports, 'default allows any port'

    assert @predicate.validate('http://example.com', nil)
    assert @predicate.validate('http://example.com:80', nil)
    assert @predicate.validate('http://example.com:443', nil)

    @predicate.ports = [nil, 80]

    assert @predicate.validate('http://example.com', nil)
    assert @predicate.validate('http://example.com:80', nil)
    assert !@predicate.validate('http://example.com:443', nil)
  end

  def test_bad_url
    assert !@predicate.validate('http:\\\\example.com\\', nil)
    assert !@predicate.validate('example.com', nil), 'human format does not validate'

    assert_equal 'http:\\\\example.com\\', @predicate.from_human('http:\\\\example.com\\'), 'malformed human format is preserved'
  end

  def test_implied_scheme
    assert_equal 'http', @predicate.implied_scheme

    assert_equal 'http://example.com/', @predicate.from_human('http://example.com/'), 'no changes'
    assert_equal 'ftp://example.com/', @predicate.from_human('ftp://example.com/'), 'no changes when scheme is not default'
    assert_equal 'http://example.com', @predicate.from_human('example.com'), 'basic implied scheme support'
    assert_equal 'http://example.com:443', @predicate.from_human('example.com:443'), 'preserve ports'

    @predicate.implied_scheme = nil

    assert_equal 'http://example.com/', @predicate.from_human('http://example.com/')
    assert_equal 'ftp://example.com/', @predicate.from_human('ftp://example.com/')
    assert_equal 'example.com', @predicate.from_human('example.com')
    assert_equal 'example.com:80', @predicate.from_human('example.com:80')
  end

  def test_error_message
    assert_equal 'must be a valid URL.', @predicate.error_message
    @predicate.error_message = 'foo  bar'
    assert_equal 'foo  bar', @predicate.error_message
  end
end