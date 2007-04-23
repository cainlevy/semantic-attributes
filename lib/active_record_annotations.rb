# active record tie-ins
module ActiveRecord
  module Annotations
    def self.included(base)
      base.extend ClassMethods
    end

    # provides a shortcut to the class's annotationset object
    def annotations
      self.class.annotations
    end

    module ClassMethods
      # provides sugary syntax for adding and querying annotations
      def method_missing(name, *args)
        begin
          super
        rescue NameError
          if /^(.*)_(is|has)_(an?_)?([^?]*)(\?)?$/.match(name.to_s)
            options = args.pop if args.last.is_a? Hash
            fields = ($1 == 'fields') ? args : [$1]
            annotation = $4
            method = ($5 == '?') ? :has? : :add

            args = [annotation]
            args << options if method == :add and options
            fields.each do |field|
              self.annotations[field].send(method, *args)
            end
          else
            raise
          end
        end
      end

      # interface with the annotationset object
      def annotations
        @annotations ||= AnnotationSet.new
      end
    end
  end
end