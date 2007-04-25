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
      #
      # the syntax supports the following forms:
      #   #{attribute}_is_#{predicate}(options = {})
      #   #{attribute}_is_a_#{predicate}(options = {})
      #   #{attribute}_is_an_#{predicate}(options = {})
      #   #{attribute}_has_#{predicate}(options = {})
      #   #{attribute}_has_a_#{predicate}(options = {})
      #   #{attribute}_has_an_#{predicate}(options = {})
      #
      # if you want to assign a predicate to multiple fields, you may replace the attribute component with the word 'fields', and pass a field list as the first argument, like this:
      #   fields_is_#{predicate}(fields = [], options = {})
      #
      # each form may also have a question mark at the end, to query whether the attribute has the predicate
      #
      # in order to avoid clashing with other method_missing setups, this syntax is checked *last*, after all other method_missing metaprogramming attempts have failed.
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