# Describes an attribute as a number. You may specify boundaries for the number (min, max, or both), and also specify whether it must be an integer.
#
# ==Options
# * :integer [boolean, default: false] - if the number is an integer (or float/decimal)
# * :above [integer, float] - when the number has a minimum
# * :below [integer, float] - when the number has a maximum
# * :range [range] - when the number has a minimum and a maximum
# * :inclusive [boolean, default: false] - if your maximum or minimum is also an allowed value. Does not work with :range.
# * :at_least [integer, float] - an easy way to say :above and :inclusive
# * :no_more_than [integer, float] - an easy way to say :below and :inclusive
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
  
  def at_least=(val)
    self.above = val
    self.inclusive = true
  end
  
  def no_more_than=(val)
    self.below = val
    self.inclusive = true
  end

  def error_message
    @error_message || range_description
  end
  
  def error_binds
    self.range ?
      {:min => self.range.first, :max => self.range.last} :
      {:min => self.above, :max => self.below}
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
    if self.range
      return :between
    end
    # if it only has one inclusive endpoint
    if inclusive
      return :greater_than_or_equal_to if self.above
      return :less_than_or_equal_to if self.below
    # if it only has one exclusive endpoint
    else
      return :greater_than if self.above
      return :less_than if self.below
    end
    # if it has no endpoints
    :not_a_number
  end
end
