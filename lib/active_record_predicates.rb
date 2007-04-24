# active record tie-ins
module ActiveRecord
  module Predicates
    def self.included(base)
      base.extend ClassMethods
    end

    # provides a shortcut to the class's PredicateSet object
    def predicates
      self.class.predicates
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
              self.predicates[field].send(method, *args)
            end
          else
            raise
          end
        end
      end

      # interface with the PredicateSet object
      def predicates
        @predicates ||= PredicateSet.new
      end
    end
  end
end