# Defines a field as a phone number.
# Currently it assumes the phone number fits the North American Numbering Plan.
# Future support of other plans will be implemented by calling code, e.g. +44 (UK) or +33 (FR). These will act as triggers for localized phone number validation.
# Options
# * implied_country_code => integer - [default: 1 - NANP (north america)]
class Predicates::PhoneNumber < Predicates::Base
  attr_accessor :implied_country_code

  def initialize(options = {})
    options[:implied_country_code] ||= 1
    super(options)
  end

  def validate(value, record)
    case value
      when Patterns::NANP
      match = $~
      valid = !match.nil?
      valid &&= (match[2] != '555' or match[3][0..1] != '01') # 555-01xx are reserved (http://en.wikipedia.org/wiki/555_telephone_number)

      else
      valid = false
    end

    valid
  end

  # check country code, then format differently for each country
  def to_human(value)
    case value
      when Patterns::NANP
      m = $~
      "(#{m[1]}) #{m[2]}-#{m[3]}"

      else
      value
    end
  end

  # strip out all non-numeric characters except a leading +
  def from_human(value)
    value = "+#{value}" if value.to_s[0..0] == '1' # north american bias
    value = "+#{implied_country_code}#{value}" unless value.to_s[0..0] == '+'

    leading_plus = (value[0..0] == '+')
    value.gsub!(/[^0-9]/, '')
    value = "+#{value}" if leading_plus
    value
  end

  class Patterns
    NANP = /^\+1([2-9][0-8][0-9])([2-9][0-9]{2})([0-9]{4})$/
  end
end