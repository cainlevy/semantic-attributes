# Provides a generic pattern predicate, which is extended and used by other pattern-based validations.
#
# WARNING: If you define a pattern, you probably want to use \A and \Z instead of ^ and $. The latter anchors are per-line, which means that multi-line strings can sneak stuff past your regular expression. For example:
#
#   @predicate.like = /^hello world$/
#   assert @predicate.validate("malicious\nhello world\ntext", nil), 'must match only one line'
#   @predicate.like = /\Ahello world\Z/
#   assert !@predicate.validate("malicious\nhello world\ntext", nil), 'must match entire string'
#
# ==Options
# * :like - a regular expression matching pattern
#
# == Example
#   field_has_a_pattern :like => /\Aim in ur [a-z]+, [a-z]+ ur [a-z]+\Z/
class Predicates::Pattern < Predicates::Base
  attr_accessor :like

  def validate(value, record)
    value = value.to_s if [Symbol, Fixnum].include?(value.class)
    value.match(self.like)
  end
end