require 'predicates'
require 'semantic_attribute'
require 'semantic_attributes'
require 'active_record_predicates'

module Predicates; end
predicates_directory = "#{File.dirname __FILE__}/lib/predicates"
Dir[File.join(predicates_directory, '*.rb')].each do |file|
  constant_name = File.basename(file, '.rb').camelcase
  Predicates.autoload(constant_name, file)
end

ActiveRecord::Base.send(:include, ActiveRecord::Predicates)