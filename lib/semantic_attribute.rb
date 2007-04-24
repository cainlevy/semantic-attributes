# a field with its assocatied predicates
class SemanticAttribute
  attr_reader :field
  def initialize(field)
    @field = field.to_sym
    @set = []
  end

  def has?(predicate)
    predicate = class_of predicate
    @set.any? {|item| item.is_a? predicate}
  end

  def get(predicate)
    predicate = class_of predicate
    @set.find {|item| item.is_a? predicate}
  end

  def add(predicate, options = {})
    predicate = class_of predicate
    @set << predicate.new(options)
  end

  protected

  # fully-qualified-name of a predicate
  def fqn(short_name)
    "Predicates::#{short_name.to_s.camelize}"
  end

  # the actual predicate class for the given name
  def class_of(short_name)
    self.fqn(short_name).constantize
  end
end