# a field with its assocatied annotations
class AnnotatedField
  attr_reader :field
  def initialize(field)
    @field = field.to_sym
    @set = []
  end

  def has?(annotation)
    annotation = class_of annotation
    @set.any? {|item| item.is_a? annotation}
  end

  def get(annotation)
    annotation = class_of annotation
    @set.find {|item| item.is_a? annotation}
  end

  def add(annotation, options = {})
    annotation = class_of annotation
    @set << annotation.new(options)
  end

  protected

  # fully-qualified-name of an annotation
  def fqn(short_name)
    "Annotations::#{short_name.to_s.camelize}"
  end

  # the actual annotation class for the given name
  def class_of(short_name)
    self.fqn(short_name).constantize
  end
end