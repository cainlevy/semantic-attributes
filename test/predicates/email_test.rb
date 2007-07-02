require File.dirname(__FILE__) + '/../test_helper'

class EmailPredicateTest < Test::Unit::TestCase
  def setup
    @predicate = Predicates::Email.new(:foo)
  end
  
  def test_validation
    assert @predicate.validate('test@example.com', nil), 'standard address'
    assert @predicate.validate('what.did-you_say@example.com', nil), 'address with punctuation in name'
    assert @predicate.validate('test@example.com.uk', nil), 'address with extended domain'
    
    assert !@predicate.validate('.test@example.com', nil), 'leading period'
    assert !@predicate.validate('test@example.com.', nil), 'trailing period'
    assert !@predicate.validate('test@example', nil), 'missing domain'
  end
  
  def test_with_mx_record
    assert @predicate.validate('test@example.com', nil), 'syntax check only'
    @predicate.with_mx_record = true
    assert !@predicate.validate('test@example.com', nil), 'syntax and mx check'
    assert @predicate.validate('test@gmail.com', nil)
  end
  
  def test_error_message
    assert_equal ' must be an email address.', @predicate.error_message
    @predicate.error_message = 'foo'
    assert_equal 'foo', @predicate.error_message
  end
end