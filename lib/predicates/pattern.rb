# provides a generic pattern predicate, which is extended and used by other pattern-based validations
# options:
# * :like - a regular expression matching pattern
class Predicates::Pattern < Predicates::Base
  attr_accessor :like

  def validate(value, record)
    value = value.to_s if value.instance_of? Symbol
    value.match(self.like)
  end

  # generic patterns don't have a difference between database formats and human formats, so these methods are stubbed out
  def to_human(v); end
  def from_human(v); end
end