# namespace for the possible predicates. any class in this namespace (besides Base) may be added as a predicate.
module Predicates
  # the base class for all predicates. defines the interface and standard settings.
  class Base
    ##
    ## Standard Configuration Options
    ##

    # the error string when validation fails
    attr_accessor :error_message

    # a condition to restrict when validation should occur. if it returns false, the validation will not happen.
    # if the value is a proc, then the proc will be called and the record object passed as the argument
    # if the value is a symbol, then a method by that name will be called on the record
    attr_accessor :validate_if

    # defines when to do the validation - during :update or :create (default is both, signified by absence of specification)
    # options: :update, :create, and :both
    attr_reader :validate_on
    def validate_on=(val)
      raise ArgumentError 'unknown value for :validate_on parameter' unless [:update, :create, :both].include? val
    end

    ##
    ## Internal
    ##

    # the initialization method provides quick support for assigning options using existing methods
    def initialize(attribute, options = {})
      @attribute = attribute
      options.each_pair do |k, v|
        self.send("#{k}=", v) if self.respond_to? "#{k}="
      end
    end

    # the attribute to which this predicate is attached. this is needed for retrieving values from a record, and is automatically handled.
    attr_reader :attribute

    # define this in the concrete class to provide a validation routine for your predicate
    def validation
      raise NotImplementedError
    end

    # define this in the concrete class to provide a method for converting from a storage format to a human readable format
    # this is good for presenting your clean, logical data in a way that people like to read.
    def to_human(value)
      raise NotImplementedError
    end

    # define this in the concrete class to provide a method for converting from a human readable format to a storage format.
    # this is good for letting people do fuzzy searches, or add values through a form in a variety of formats, but still retain consistent data.
    def from_human(value)
      raise NotImplementedError
    end
  end
end