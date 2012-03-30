I18n.load_path << File.dirname(__FILE__) + '/semantic_attributes/locale/en.yml'
require 'core_ext/class'
require 'active_record/validation_recursion_control'
require 'predicates'
require 'predicates/base'
require 'predicates/enumerated'
require 'predicates/pattern'
require 'predicates/aliased'
require 'predicates/association'
require 'predicates/blacklisted'
require 'predicates/domain'
require 'predicates/email'
require 'predicates/hex_color'
require 'predicates/length'
require 'predicates/number'
require 'predicates/phone_number'
require 'predicates/required'
require 'predicates/same_as'
require 'predicates/size'
require 'predicates/time'
require 'predicates/unique'
require 'predicates/url'
require 'predicates/usa_state'
require 'predicates/usa_zip_code'
require 'predicates/aliased'
require 'semantic_attributes/attribute'
require 'semantic_attributes/attribute_formats'
require 'semantic_attributes/predicates'
require 'semantic_attributes/set'
require 'semantic_attributes/version'

module SemanticAttributes
  if defined? Rails::Railtie
    require 'rails'
    class Railtie < Rails::Railtie
      initializer 'semantic_attributes.insert_into_active_record' do
        ActiveSupport.on_load :active_record do
          SemanticAttributes::Railtie.insert
        end
      end
      # rake_tasks do
      #   load "tasks/semantic_attributes.rake"
      # end
    end
  end

  class Railtie
    def self.insert
      ActiveRecord::Base.send(:include, SemanticAttributes::Predicates)
      ActiveRecord::Base.send(:include, SemanticAttributes::AttributeFormats)
      ActiveRecord::Base.send(:include, ActiveRecord::ValidationRecursionControl)
    end
  end
end

SemanticAttributes::Railtie.insert
