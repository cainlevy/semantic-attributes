=begin
m.attribute                        get machine format [normal]
m.attribute_for_human              get human format [new]
m.attribute=                       set from possibly-human value [override wrapper]
M.humanize(attribute, object)      where 'object' is a string, integer, date, whatever [new]
M.machinize(attribute, object)     where 'object' is a simple string, array, or hash [new]
=end
module ActiveRecord
  module AttributeFormats
    def self.included(base)
      base.extend ClassMethods
      
      # this method is private
      base.class_eval do
        unless private_instance_methods.include? 'write_attribute_without_formats' # was having stack problems when running tests
        def write_attribute_with_formats(attr, value)
          value = self.class.machinize(attr, value)
          write_attribute_without_formats attr, value
        end
        alias_method_chain :write_attribute, :formats
        end
      end
    end
    
    def method_missing(method_name, *args, &block)
      if md = method_name.to_s.match(/_for_human$/) and semantic_attributes.include?(md.pre_match)
        self.class.humanize(md.pre_match, self.send(md.pre_match))
      else
        super
      end
    end
    
    def respond_to?(*args)
      if md = method_name.to_s.match(/_for_human$/) and semantic_attributes.include?(md.pre_match)
        true
      end
    end
    
    module ClassMethods
      # converts the object into human format according to the predicates for the attribute.
      # the object may really be anything: string, integer, date, etc.
      def humanize(attr, obj)
        self.semantic_attributes[attr].predicates.inject(obj) { |val, predicate| val = predicate.to_human(val) }
      end
      
      # converts the object into machine format according to the predicates for the attribute.
      # the object should be a simple object like a string, array, or hash. but really, it depends on the the predicates.
      def machinize(attr, obj)
        self.semantic_attributes[attr].predicates.inject(obj) { |val, predicate| val = predicate.from_human(val) }
      end
    end
  end
end