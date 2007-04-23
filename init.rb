require 'annotations'
require 'annotated_field'
require 'annotation_set'
require 'active_record_annotations'

ActiveRecord::Base.send(:include, ActiveRecord::Annotations)