# active record tie-ins
module ActiveRecord
  module Predicates
    def self.included(base)
      base.class_eval do
        extend ClassMethods

        attribute_method_suffix '_valid?'

        validate :validate_predicates

        class_inheritable_reader :semantic_attributes
        write_inheritable_attribute :semantic_attributes, SemanticAttributes.new
      end
    end

    # the validation hook that checks all predicates
    def validate_predicates
      semantic_attributes.each do |attribute|
        attribute.predicates.each do |predicate|
          next unless validate_predicate?(predicate)

          value = self.send(attribute.field)
          if value.blank?
            # it's empty, so add an error or not but either way move along
            self.errors.add(attribute.field, _(predicate.error_message)) unless predicate.allow_empty?
            next
          end

          unless predicate.validate(value, self)
            self.errors.add(attribute.field, _(predicate.error_message))
          end
        end
      end
    end

    protected

    # Returns true if this attribute would pass validation during the next save.
    # Intended to be called via attribute suffix, like:
    #   User#login_valid?
    def attribute_valid?(attr)
      semantic_attributes[attr.to_sym].predicates.all? do |p|
        !validate_predicate?(p) or (self.send(attr).blank? and p.allow_empty?) or p.validate(self.send(attr), self)
      end
    end

    # Returns true if the given predicate (for a specific attribute) should be validated.
    def validate_predicate?(predicate)
      case predicate.validate_if
        when Symbol
        return false unless send(predicate.validate_if)

        when Proc
        return false unless predicate.validate_if.call(self)
      end

      case predicate.validate_on
        when :create
        return false unless new_record?

        when :update
        return false if new_record?
      end

      true
    end

    module ClassMethods
      # Provides sugary syntax for adding and querying predicates
      #
      # The syntax supports the following forms:
      #   #{attribute}_is_#{predicate}(options = {})
      #   #{attribute}_is_a_#{predicate}(options = {})
      #   #{attribute}_is_an_#{predicate}(options = {})
      #   #{attribute}_has_#{predicate}(options = {})
      #   #{attribute}_has_a_#{predicate}(options = {})
      #   #{attribute}_has_an_#{predicate}(options = {})
      #
      # If you want to assign a predicate to multiple fields, you may replace the attribute component with the word 'fields', and pass a field list as the first argument, like this:
      #   fields_are_#{predicate}(fields = [], options = {})
      #
      # Each form may also have a question mark at the end, to query whether the attribute has the predicate
      #
      # In order to avoid clashing with other method_missing setups, this syntax is checked *last*, after all other method_missing metaprogramming attempts have failed.
      def method_missing(name, *args)
        begin
          super
        rescue NameError
          if /^(.*)_(is|has)_(an?_)?([^?]*)(\?)?$/.match(name.to_s)
            options = args.pop if args.last.is_a? Hash
            fields = ($1 == 'fields') ? args : [$1]
            predicate = $4
            if $5 == '?'
              self.semantic_attributes[fields.first].has? predicate
            else
              args = [predicate]
              args << options if options
              fields.each do |field|
                self.semantic_attributes[field].add *args
              end
            end
          else
            raise
          end
        end
      end

      # Provides a way to pre-validate a single value out of context of
      # an entire record. This is helpful for validating parts of a form
      # before it has been submitted.
      #
      # For values that are (in)valid only in context, such as the common
      # :password_confirmation (which is only valid with a matching :password),
      # additional values may be specified.
      #
      # WARNING: I still have not figured out what to do about differences in
      # validation for new/existing records.
      #
      # Returns first error message if value is expected invalid.
      #
      # Example:
      #   User.expected_error_for(:username, "bob")
      #   => "has already been taken."
      #   User.expected_error_for(:username, "bob2392")
      #   => nil
      #   User.expected_error_for(:password_confirmation, "mismatched", :password => "opensesame")
      #   => "must be the same as password."
      def expected_error_for(attribute, value, extra_values = {})
        @record = self.new(extra_values)
        semantic_attributes[attribute.to_sym].predicates.each do |predicate|
          return predicate.error_message unless predicate.validate(value, @record)
        end
        nil
      end
    end
  end
end