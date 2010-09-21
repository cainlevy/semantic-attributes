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
    @error_message || range_description
  end
  
  def error_binds
    self.range ?
      {:min => self.range.first, :max => self.range.last} :
      {:min => self.above, :max => self.below, :count => self.exactly}
  end

  def validate(value, record)
    l = tokenize(value).length
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
  
  def normalize(v)
    (v and v.is_a? String) ? v.gsub("\r\n", "\n") : v
  end

  protected
  
  def tokenize(value)
    case value
      when Array, Hash: value
      else              value.to_s.mb_chars
    end
  end
  
  def range_description
    return :inexact_length if self.exactly
    return :wrong_length if self.range
    return :too_short if self.above
    return :too_long if self.below
    raise 'undetermined range'
  end
end
