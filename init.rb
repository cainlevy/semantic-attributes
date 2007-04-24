require 'semantic_attributes'
require 'semantic_attribute'
require 'predicate_set'
require 'active_record_predicates'

ActiveRecord::Base.send(:include, ActiveRecord::Predicates)