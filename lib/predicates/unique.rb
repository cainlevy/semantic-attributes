# Describes an attribute as being unique, possibly within a certain scope.
#
# ==Options
# * :scope [array] - a list of other fields that define the context for uniqueness. it's like defining a multi-column uniqueness constraint.
# * :case_sensitive [boolean, default false] - whether case matters for uniqueness.
#
# ==Examples
#   field_is_unique :case_sensitive => true
#   field_is_unique :scope => [:other_field, :another_other_field]
class Predicates::Unique < Predicates::Base
  attr_accessor :case_sensitive
  attr_accessor :scope

  def initialize(attribute, options = {})
    defaults = {
      :scope => [],
      :case_sensitive => false
    }
    super attribute, defaults.merge(options)
  end

  def error_message
    @error_message || "has already been taken."
  end

  def validate(value, record)
    fields_values = [[@attribute, value]]
    [scope].flatten.each { |attribute| fields_values << [attribute, record.send(attribute)] }

    conditions_array = ['']
    fields_values.each do |(attribute, attribute_value)|
      field_sql = "#{record.class.table_name}.#{attribute}"
      comparison_value = attribute_value

      if record.class.columns_hash[attribute.to_s].text? and not self.case_sensitive
        field_sql = "LOWER(#{field_sql})"
        comparison_value = comparison_value.to_s.downcase unless comparison_value.nil?
      end
      field_sql << ' ' << record.class.send(:attribute_condition, comparison_value)

      conditions_array.first << ' AND ' unless conditions_array.first.empty?
      conditions_array.first << field_sql
      conditions_array << comparison_value
    end

    result = record.class.find(:all, :conditions => conditions_array, :limit => 2)
    return (result.size < 1 or result.first == record)
  end
end
