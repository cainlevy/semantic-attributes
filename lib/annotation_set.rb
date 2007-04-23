# a set of AnnotatedField objects
class AnnotationSet
  def initialize
    @set = []
  end

  def add(annotated_field)
    raise ArgumentError, 'Must pass an AnnotatedField object' unless annotated_field.is_a? AnnotatedField
    @set << annotated_field
  end

  # method for field lookups. creates the field if it doesn't exist.
  def [](field)
    field = field.to_sym
    annotated_field = @set.find {|i| i.field == field}
    @set << annotated_field = AnnotatedField.new(field) unless annotated_field
    annotated_field
  end
end