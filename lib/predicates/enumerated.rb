class Predicates::Enumerated < Predicates::Base
  attr_accessor :options

  def validate(value, record)
    self.options.include? value
  end

  def to_human(v); v; end
  def from_human(v); v; end
end