module SemanticAttributes #:nodoc:
  module AttributeFormats
    def self.included(base)
      base.extend ClassMethods
    end
    
    def respond_to?(method_name, *args)
      if md = method_name.to_s.match(/_for_human$/) and semantic_attributes.include?(md.pre_match)
        true
      else
        super
      end
    end
    
    protected
    
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

    module ClassMethods
      # converts the object into human format according to the predicates for the attribute.
      # the object may really be anything: string, integer, date, etc.
      def humanize(attr, obj)
        self.semantic_attributes[attr].predicates.inject(obj) { |val, predicate| val = predicate.to_human(val) }
      end

      # converts the object into machine format according to the predicates for the attribute.
      # the object should be a simple object like a string, array, or hash. but really, it depends on the the predicates.
      def normalize(attr, obj)
        self.semantic_attributes[attr].predicates.inject(obj) { |val, predicate| val = predicate.normalize(val) }
      end
      
      protected

      def define_normalization_method_for(attr)
        self.define_attribute_methods if self.respond_to? :generated_methods? and !self.generated_methods?
        
        writer = "#{attr}_with_normalization="
        old_writer = "#{attr}_without_normalization=".to_sym
        unless instance_methods.include? writer
          define_method writer do |val|
            send(old_writer, self.class.normalize(attr, val))
          end
          alias_method_chain "#{attr}=", :normalization
        end
      rescue NameError
        # so the top line of the backtrace shows the proper method
        raise NameError, $!.message, caller[4..-1]
      end

    end
  end
end
