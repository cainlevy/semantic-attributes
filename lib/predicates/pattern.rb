# Provides a generic pattern predicate, which is extended and used by other pattern-based validations.
#
# ==Options
# * :like - a regular expression matching pattern
#
# == Example
#   field_has_a_pattern :like => /\Aim in ur [a-z]+, [a-z]+ ur [a-z]+\Z/
class Predicates::Pattern < Predicates::Base
  attr_accessor :like

  def validate(value, record)
    value = value.to_s if value.instance_of? Symbol
    value.match(self.like)
  end
end