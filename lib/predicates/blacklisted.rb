# Blacklisted is the inverse of Enumerated. This is how you can say that a field may _not_ be certain values.
#
# ==Example
#   field_is_blacklisted :options => ['disallowed_value_one', 'disallowed_value_two']
class Predicates::Blacklisted < Predicates::Enumerated
  def validate(*args)
    !super
  end
end