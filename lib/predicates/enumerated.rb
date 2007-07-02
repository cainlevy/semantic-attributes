# A basic pattern where the values are enumerated.
#
# ==Options
# * :options - a complete collection of values that the attribute may contain
#
# ==Example
#   field_is_enumerated :options => ['allowed_value_one', 'allowed_value_two']
class Predicates::Enumerated < Predicates::Base
  attr_accessor :options

  def error_message
    @error_message || " is not an allowed option."
  end

  def validate(value, record)
    self.options.include? value
  end
end