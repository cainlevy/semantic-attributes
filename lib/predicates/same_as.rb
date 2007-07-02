# Requires that one field must be the same as another field. Useful when combined with virtual attributes to describe things like password or email confirmation.
#
# ==Options
# * :method [string, symbol] - the other record attribute that must equal this one
#
# ==Example
#   field_is_same_as :other_field
class Predicates::SameAs < Predicates::Base
  attr_accessor :method

  def validate(value, record)
    value == record.send(self.method)
  end
end