require 'core_ext/class'

ActiveRecord::Base.class_eval do
  include SemanticAttributes::Predicates
  include SemanticAttributes::AttributeFormats
  include ActiveRecord::ValidationRecursionControl
end

# localization mock
ActiveRecord::Base.class_eval do
  unless respond_to? :_
    def _(s); s; end
  end
end
