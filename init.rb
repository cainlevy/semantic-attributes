require 'core_ext/class'

ActiveRecord::Base.send(:include, ActiveRecord::Predicates)
ActiveRecord::Base.send(:include, ActiveRecord::AttributeFormats)
ActiveRecord::Base.send(:include, ActiveRecord::ValidationRecursionControl)

# localization mock
ActiveRecord::Base.class_eval do
  unless respond_to? :_
    def _(s); s; end
  end
end
