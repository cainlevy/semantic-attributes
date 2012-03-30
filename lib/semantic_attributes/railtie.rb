require 'core_ext/class'

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
