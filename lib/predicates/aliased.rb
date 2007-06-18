# A special case of enumeration where the values are actually aliased for humans.
# Create this like a normal enumeration, but make :options a Hash of {value => alias}
class Predicates::Aliased < Predicates::Enumerated
  def to_human(v)
    options[v]
  end

  def from_human(v)
    options.index(v)
  end
end