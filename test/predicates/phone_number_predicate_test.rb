require File.dirname(__FILE__) + '/../test_helper'

class PhoneNumberPredicateTest < Test::Unit::TestCase
  def setup
    @predicate = Predicates::PhoneNumber.new
  end

  def test_north_american_bias
    assert_equal 1, @predicate.implied_country_code, 'default implied country code is 1 (north america)'
  end

  def test_to_human_nanp
    assert_equal '(222) 333-4444', @predicate.to_human('+12223334444')
  end

  def test_validate_nanp
    assert !@predicate.validate('12223334444', nil), 'requires country code indicator (+)'
    assert @predicate.validate('+12223334444', nil), 'requires country code indicator (+)'

    assert !@predicate.validate('+11223334444', nil), 'first digit of area code may not be 1'
    assert !@predicate.validate('+12923334444', nil), 'second digit of area code may not be 9'
    assert !@predicate.validate('+12221334444', nil), 'first digit of exchange code may not be 1'
    assert !@predicate.validate('+1222333444', nil), 'must be 11 characters long'

    assert !@predicate.validate('+12225550155', nil), 'restricted 555 code'
    assert @predicate.validate('+12225550099', nil), 'allowed 555 code'
    assert @predicate.validate('+12225550200', nil), 'allowed 555 code'
  end

  def test_from_human
    @predicate.implied_country_code = 99

    assert_equal '+12223334444', @predicate.from_human('12223334444'), 'recognizes north american country code without +'
    assert_equal '+12223334444', @predicate.from_human('+12223334444'), 'leaves country codes alone if they exist'
    assert_equal '+992223334444', @predicate.from_human('2223334444'), 'adds implied country code'
    assert_equal '+12223334444', @predicate.from_human('1 (222) 333.4444'), 'ignores various formatting characters'
    assert_equal '+992223334444', @predicate.from_human('222typo333oops4444'), 'ignores non-numeric characters'
  end
end