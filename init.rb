require 'predicates'
require 'semantic_attribute'
require 'semantic_attributes'
require 'active_record_predicates'

ActiveRecord::Base.send(:include, ActiveRecord::Predicates)