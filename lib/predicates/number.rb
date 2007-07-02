# Describes an attribute as a number.
#
# ==Example
#   field_is_a_number :integer => true
class Predicates::Number < Predicates::Base
  # whether to require an integer value
  attr_accessor :integer

  def error_message
    @error_message || " must be a number."
  end

  def validate(value, record)
    if integer
      value.to_s.match(/\A[+-]?[0-9]+\Z/) unless value.is_a? Hash or value.is_a? Array
    else
      begin
        Kernel.Float(value)
        true
      rescue ArgumentError, TypeError
        false
      end
    end
  end
end