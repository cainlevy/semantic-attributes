module ActiveRecord #:nodoc:
  # Some predicates define different data formats for machines vs humans. For example, your code might always want phone numbers to be integers, but that's not so readable for humans.
  #
  # SemanticAttributes uses the following pattern to handle the different formats:
  #
  # user#phone_number::                 get machine format [normal behavior]
  # user#phone_number_for_human::          get human format [new]
  # user#phone_number=::                   set from possibly-human value [override wrapper]
  #
  # These patterns are supported by the following helpers:
  #
  # User.humanize(attribute, object)::     where 'object' is a string, integer, date, whatever
  # User.machinize(attribute, object)::    where 'object' is a simple string, array, or hash, as from form parameters
  #
  module AttributeFormats
    def self.included(base)
      base.extend ClassMethods

      # this method is private
      base.class_eval do
        def write_attribute_with_formats(attr, value)
          value = self.class.machinize(attr, value) if semantic_attributes and semantic_attributes.include? attr
          write_attribute_without_formats attr, value
        end
        alias_method_chain :write_attribute, :formats
      end
    end

    def method_missing(method_name, *args, &block)
      if md = method_name.to_s.match(/_for_human$/) and semantic_attributes.include?(md.pre_match)
        self.class.humanize(md.pre_match, self.send(md.pre_match))
      else
        begin
          super
        rescue
          raise $!, $!.to_s, caller
        end
      end
    end

    def respond_to?(method_name, *args)
      if md = method_name.to_s.match(/_for_human$/) and semantic_attributes.include?(md.pre_match)
        true
      else
        super
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