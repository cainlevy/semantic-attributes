# Lets you declare a min/max/exact length for something. This works for arrays and strings both.
#
# ==Options
# * :above [integer] - when the attribute has a minimum
# * :below [integer] - when the attribute has a maximum
# * :range [range] - when the attribute has a minimum and a maximum
# * :exactly [integer] - when the attribute must be exactly some length
#
# ==Examples
#   field_has_length :exactly => 3
#   field_has_length :above => 5
#   field_has_length :range => 4..8
class Predicates::Length < Predicates::Base
  # when the length has just a min
  attr_accessor :above

  # when the length has just a max
  attr_accessor :below

  # when the length has both a max and a min
  attr_accessor :range

  # when the length must be exact
  attr_accessor :exactly

  def error_message
    @error_message || "must be #{range_description} characters long."
  end

  def validate(value, record)
    l = value.to_s.chars.length
    if self.exactly
      l == self.exactly
    elsif self.range
      self.range.include? l
    elsif self.above
      l > self.above
    elsif self.below
      l < self.below
    else
      true
    end
  end

  protected

  def range_description
    return self.exactly.to_s if self.exactly
    return "#{self.range.first} to #{self.range.last}" if self.range
    return "more than #{self.above}" if self.above
    return "less than #{self.below}" if self.below
    raise 'undetermined range'
  end
end