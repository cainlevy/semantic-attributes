# requires that one field must be the same as another field
class Predicates::SameAs < Predicates::Base
  attr_accessor :method

  def validate(value, record)
    value == record.send(self.method)
  end

  def to_human(v); v; end
  def from_human(v); v; end
end