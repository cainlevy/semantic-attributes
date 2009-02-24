require 'core_ext/class'

ActiveRecord::Base.class_eval do
  include SemanticAttributes::Predicates
  include SemanticAttributes::AttributeFormats
  include ActiveRecord::ValidationRecursionControl
end

I18n.load_path << File.dirname(__FILE__) + '/lib/semantic_attributes/locale/en.yml'
