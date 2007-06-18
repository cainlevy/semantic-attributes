# Describes an attribute as being unique, possibly within a certain scope.
# options:
# * :scope => [...] - a list of other fields that define the context for uniqueness. it's like defining a multi-column uniqueness constraint.
# * :case_sensitive => boolean - whether case matters for uniqueness.
class Predicates::Unique < Predicates::Enumerated
  attr_accessor :case_sensitive
  attr_accessor :scope
  
  def initialize(attribute, options = {})
    defaults = {
      :scope => [],
      :case_sensitive => true
    }
    super attribute, defaults.merge(options)
  end

  def error_message
    @error_message || "%s has already been taken."
  end

  def validate(value, record)
    fields_values = [[@attribute, value]]
    self.scope.each { |attribute| fields_values << [attribute, record.send(attribute)] }
    
    conditions_array = ['']
    fields_values.each do |pair|
      attribute, attribute_value = *pair
      sql = "#{record.class.table_name}.#{attribute}"
      unless self.case_sensitive
        sql = "LOWER(#{sql})"
        attribute_value.downcase!
      end
      sql << ' ' << record.class.send(:attribute_condition, attribute_value)
      
      conditions_array.first << ' AND ' unless conditions_array.first.empty?
      conditions_array.first << sql
      conditions_array << attribute_value
    end

    result = record.class.find(:all, :conditions => conditions_array, :limit => 2)
    return (result.size < 1 or result.first == record)
  end

  def to_human(v); v; end
  def from_human(v); v; end
end