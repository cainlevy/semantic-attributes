# A basic pattern where the values are enumerated.
class Predicates::Enumerated < Predicates::Base
  attr_accessor :options
  
  def error_message
    @error_message || "%s is not an allowed option."
  end

  def validate(value, record)
    self.options.include? value
  end

  def to_human(v); v; end
  def from_human(v); v; end
end