# Requires that one field must be the same as another field. Useful when combined with virtual attributes to describe things like password or email confirmation.
#
# ==Options
#
# ==Example
#   field_is_same_as :method => :other_field
class Predicates::SameAs < Predicates::Base
  attr_accessor :method

  def error_message
    @error_message ||= "must be the same as #{method}."
  end

  def validate(value, record)
    value == record.send(self.method)
  end
end