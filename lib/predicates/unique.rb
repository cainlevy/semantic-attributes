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
    @error_message || :taken
  end

  def validate(value, record)  
    klass = record.class
  
    # merge all the scope fields with this one. they must all be unique together.
    # no special treatment -- case sensitivity applies to all or none.
    values = [scope].flatten.collect{ |attr| [attr, record.send(attr)] }
    values << [@attribute, value]

    conditions_sql = []
    conditions_params = []
    values.each do |(attr, attr_value)|
      field_sql, comparison_value = *comparison_for(attr, attr_value, klass)
      conditions_sql    << field_sql
      conditions_params << comparison_value
    end
    
    unless record.new_record?
      conditions_sql    << "#{klass.quoted_table_name}.#{klass.primary_key} <> ?"
      conditions_params << record.id
    end

    !klass.exists?([conditions_sql.join(" AND "), *conditions_params])
  end
  
  protected
  
  def comparison_for(field, value, klass)
    quoted_field = "#{klass.quoted_table_name}.#{klass.connection.quote_column_name(field)}"
  
    if klass.columns_hash[field.to_s].text?      
      if case_sensitive
        # case sensitive text comparison in any database
        ["#{quoted_field} #{klass.connection.case_sensitive_equality_operator} ?", value]
      elsif mysql?(klass.connection)
        # case INsensitive text comparison in mysql - yes this is a database specific optimization. i'm always open to better ways. :)
        ["#{quoted_field} = ?", value]
      else
        # case INsensitive text comparison in most databases
        ["LOWER(#{quoted_field}) = ?", value.to_s.downcase]
      end
    else
      # non-text comparison
      [klass.send(:attribute_condition, quoted_field, value), value]
    end
  end
  
  def mysql?(connection)
    (defined?(ActiveRecord::ConnectionAdapters::MysqlAdapter) and connection.is_a?(ActiveRecord::ConnectionAdapters::MysqlAdapter)) or
      (defined?(ActiveRecord::ConnectionAdapters::Mysql2Adapter) and connection.is_a?(ActiveRecord::ConnectionAdapters::Mysql2Adapter))
  end
end
