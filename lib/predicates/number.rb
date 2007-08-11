# Describes an attribute as a number. You may specify boundaries for the number (min, max, or both), and also specify whether it must be an integer.
#
# ==Options
# * :integer [boolean, default: false] - if the number is an integer (or float/decimal)
# * :above [integer, float] - when the number has a minimum
# * :below [integer, float] - when the number has a maximum
# * :range [range] - when the number has a minimum and a maximum
# * :inclusive [boolean, default: false] - if your maximum or minimum is also an allowed value. Does not work with :range.
#
# ==Examples
#   field_is_a_number :integer => true
#   field_is_a_number :range => 1..5, :integer => true
#   field_is_a_number :above => 4.5
#   field_is_a_number :below => 4.5, :inclusive => true
class Predicates::Number < Predicates::Base
  # whether to require an integer value
  attr_accessor :integer

  # when the number has a minimum value, but no maximum
  attr_accessor :above

  # when the number has a maximum value, but no minimum
  attr_accessor :below

  # when the number has both a maximum and a minimum value
  attr_accessor :range

  # meant to be used with :above and :below, when you want the endpoint to be inclusive.
  # with the :range option you can just specify inclusion using the standard Ruby range syntax.
  attr_accessor :inclusive

  def error_message
    @error_message || "must be a number#{range_description}."
  end

  def validate(value, record)
    # check data type
    valid = if self.integer
        # if it must be an integer, do a regexp check for digits only
        value.to_s.match(/\A[+-]?[0-9]+\Z/) unless value.is_a? Hash or value.is_a? Array
      else
        # if it can also be a float or decimal, then try a conversion
        begin
          Kernel.Float(value)
          true
        rescue ArgumentError, TypeError
          false
        end
      end

    # if it's the right data type, then also check boundaries
    valid &&= if self.range
        self.range.include? value
      elsif self.above
        operator = self.inclusive ? :>= : :>
        value.send operator, self.above
      elsif self.below
        operator = self.inclusive ? :<= : :<
        value.send operator, self.below
      else
        true
      end

    valid
  end

  protected

  def range_description
    # if it has two endpoints
    return " from #{self.range.first} #{self.range.exclude_end? ? 'to' : 'through'} #{self.range.last}" if self.range
    # if it only has one inclusive endpoint
    if inclusive
      return " at least #{self.above}" if self.above
      return " no more than #{self.below}" if self.below
    # if it only has one exclusive endpoint
    else
      return " greater than #{self.above}" if self.above
      return " less than #{self.below}" if self.below
    end
    # if it has no endpoints
  end
end