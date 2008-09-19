require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')
require 'actionmailer'

class EmailPredicateTest < Test::Unit::TestCase
  def setup
    @predicate = Predicates::Email.new(:foo)
  end

  ##
  ## Test cases from Alex Dunae's validates_email_format_of
  ## see http://code.dunae.ca/validates_email_format_of/trunk/test/validates_email_format_of_test.rb
  ##

  def test_should_allow_valid_email_addresses
    ['valid@example.com',
     'Valid@test.example.com',
     'valid+valid123@test.example.com',
     'valid_valid123@test.example.com',
     'valid-valid+123@test.example.co.uk',
     'valid-valid+1.23@test.example.com.au',
     'valid@example.co.uk',
     'v@example.com',
     'valid@example.ca',
     'valid_@example.com',
     'valid123.456@example.org',
     'valid123.456@example.travel',
     'valid123.456@example.museum',
     'valid@example.mobi',
     'valid@example.info',
     'valid-@example.com',
  # from RFC 3696, page 6
     'customer/department=shipping@example.com',
     '$A12345@example.com',
     '!def!xyz%abc@example.com',
     '_somename@example.com',
  # apostrophes
     "test'test@example.com",
  # from http://www.rfc-editor.org/errata_search.php?rfc=3696
     '"Abc\@def"@example.com',
     '"Fred\ Bloggs"@example.com',
     '"Joe.\\Blow"@example.com',
     ].each do |email|
      assert @predicate.validate(email, nil), "#{email} should be valid"
    end
  end

  def test_should_not_allow_invalid_email_addresses
    ['invalid@example-com',
  # period can not start local part
     '.invalid@example.com',
  # period can not end local part
     'invalid.@example.com',
  # period can not appear twice consecutively in local part
     'invali..d@example.com',
     'invalid@example.com.',
     'invalid@example.com_',
     'invalid@example.com-',
     'invalid-example.com',
     'invalid@example.b#r.com',
     'invalid@example.c',
     'invali d@example.com',
     'invalidexample.com',
     'invalid@example.',
  # from http://tools.ietf.org/html/rfc3696, page 5
  # corrected in http://www.rfc-editor.org/errata_search.php?rfc=3696
     'Fred\ Bloggs_@example.com',
     'Abc\@def+@example.com',
     'Joe.\\Blow@example.com',
  # too lengthy
     "#{"a".rjust(65, 'a')}@example.com",
     "test@#{"a.com".rjust(256, 'a')}"
     ].each do |email|
      assert !@predicate.validate(email, nil), "#{email} should not be valid"
    end
  end

  def test_with_mx_record
    assert @predicate.validate('test@example.com', nil), 'syntax check only'
    @predicate.with_mx_record = true
    assert !@predicate.validate('test@example.com', nil), 'syntax and mx check'
    assert @predicate.validate('test@gmail.com', nil)
  end

  def test_error_message
    assert_equal 'must be an email address.', @predicate.error_message
    @predicate.error_message = 'foo'
    assert_equal 'foo', @predicate.error_message
  end
end