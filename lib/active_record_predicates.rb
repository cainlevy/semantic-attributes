# active record tie-ins
module ActiveRecord
  module Predicates
    def self.included(base)
      base.extend ClassMethods
    end

    # provides a shortcut to the class's SemanticAttributes object
    def semantic_attributes
      self.class.semantic_attributes
    end

    module ClassMethods
      # provides sugary syntax for adding and querying predicates
      def method_missing(name, *args)
        begin
          super
        rescue NameError
          if /^(.*)_(is|has)_(an?_)?([^?]*)(\?)?$/.match(name.to_s)
            options = args.pop if args.last.is_a? Hash
            fields = ($1 == 'fields') ? args : [$1]
            predicate = $4
            method = ($5 == '?') ? :has? : :add

            args = [predicate]
            args << options if method == :add and options
            fields.each do |field|
              self.semantic_attributes[field].send(method, *args)
            end
          else
            raise
          end
        end
      end

      # interface with the SemanticAttributes object
      def semantic_attributes
        @semantic_attributes ||= SemanticAttributes.new
      end
    end
  end
end