# a set of SemanticAttribute objects, which themselves contain Predicates
class PredicateSet
  def initialize
    @set = []
  end

  def add(semantic_attribute)
    raise ArgumentError, 'Must pass a SemanticAttribute object' unless semantic_attribute.is_a? SemanticAttribute
    @set << semantic_attribute
  end

  # method for field lookups. creates the field if it doesn't exist.
  def [](field)
    field = field.to_sym
    semantic_attribute = @set.find {|i| i.field == field}
    @set << semantic_attribute = SemanticAttribute.new(field) unless semantic_attribute
    semantic_attribute
  end
end