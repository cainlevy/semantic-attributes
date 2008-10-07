# a set of SemanticAttributes::Attribute objects, which themselves contain Predicates
class SemanticAttributes::Set
  include Enumerable

  def initialize
    @set = []
  end

  def add(semantic_attribute)
    unless semantic_attribute.is_a? SemanticAttributes::Attribute
      raise ArgumentError, 'Must pass a SemanticAttributes::Attribute object'
    end
    @set << semantic_attribute
  end

  # method for field lookups. creates the field if it doesn't exist.
  def [](field)
    field = field.to_sym
    semantic_attribute = @set.find {|i| i.field == field}
    self.add(semantic_attribute = SemanticAttributes::Attribute.new(field)) unless semantic_attribute
    semantic_attribute
  end

  # method for field lookups which does *not* create the field if it doesn't exist
  def include?(field)
    field = field.to_sym
    @set.find {|i| i.field == field} ? true : false
  end

  def each
    @set.each do |i|
      yield i
    end
  end

  private
  def initialize_copy(from)
    @set = from.instance_variable_get('@set').clone
  end
end
