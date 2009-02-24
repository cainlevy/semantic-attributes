# Blacklisted is the inverse of Enumerated. This is how you can say that a field may _not_ be certain values.
#
# ==Example
#   field_is_blacklisted :not => ['disallowed_value_one', 'disallowed_value_two']
class Predicates::Blacklisted < Predicates::Base
  # whether the comparison is case-sensitive
  attr_accessor :case_sensitive

  # the blacklist
  attr_accessor :restricted

  def error_message
    @error_message || :exclusion
  end

  def validate(val, record)
    if self.case_sensitive
      !self.restricted.include? val
    else
      !self.restricted.any? {|r| r.to_s.downcase == val.to_s.downcase }
    end
  end
end
