module Predicates
  # The base class for all predicates. Defines the interface and standard settings.
  #
  # All predicates that inherit from Base get the following options:
  #
  #   :error_message   Feedback for the user if the validation fails. Remember that Rails will prefix the attribute name.
  #   :validate_if     Restricts when the validation can happen. If it returns false, validation will not happen. May be a proc (with the record object as the argument) or a symbol that names a method on the record to call.
  #   :validate_on     When to do the validation, during :update, :create, or both (default).
  #   :or_empty        Whether to allow empty/nil values during validation (default: true)
  class Base
    ##
    ## Standard Configuration Options
    ##

    # the error string when validation fails
    attr_accessor :error_message
    alias_accessor :message, :error_message

    # a condition to restrict when validation should occur. if it returns false, the validation will not happen.
    # if the value is a proc, then the proc will be called and the record object passed as the argument
    # if the value is a symbol, then a method by that name will be called on the record
    attr_accessor :validate_if
    alias_accessor :if, :validate_if

    # defines when to do the validation - during :update or :create (default is both, signified by absence of specification)
    # options: :update, :create, and :both
    attr_reader :validate_on
    def validate_on=(val)
      raise ArgumentError('unknown value for :validate_on parameter') unless [:update, :create, :both].include? val
      @validate_on = val
    end
    alias_accessor :on, :validate_on

    # whether to allow empty (and nil) values during validation (default: true)
    attr_writer :or_empty
    def allow_empty?
      @or_empty ? true : false
    end

    ##
    ## Internal
    ##

    # the initialization method provides quick support for assigning options using existing methods
    def initialize(attribute_name, options = {})
      @attribute = attribute_name
      @validate_on = :both
      @or_empty = true
      options.each_pair do |k, v|
        self.send("#{k}=", v)
      end
    end

    # define this in the concrete class to provide a validation routine for your predicate
    def validate(value, record)
      raise NotImplementedError
    end

    # define this in the concrete class to provide a method for converting from a storage format to a human readable format
    # this is good for presenting your clean, logical data in a way that people like to read.
    def to_human(value)
      value
    end

    # define this in the concrete class to provide a method for converting from a human readable format to a storage format.
    # this is good for letting people do fuzzy searches, or add values through a form in a variety of formats, but still retain consistent data.
    # really, consider this a normalization routine for form input.
    def from_human(value)
      value
    end
  end
end
