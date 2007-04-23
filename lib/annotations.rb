# namespace for the possible annotations. any class in this namespace (besides Base) may be added as an annotation.
module Annotations
  # the base class for all annotations. defines the interface and standard settings.
  class Base
    # the error string when validation fails
    attr_accessor :error

    # the initialization method provides quick support for assigning options using existing methods
    def initialize(options = {})
      options.each_pair do |k, v|
        self.send("#{k}=", v) if self.respond_to? "#{k}="
      end
    end

    # overwrite this to provide a validation routine for your annotation
    def validation
      raise MethodNotImplementedError
    end

    # overwrite this to provide a method for converting from a storage format to a human readable format
    # this is good for presenting your clean, logical data in a way that people like to read.
    def to_human(value)
      raise MethodNotImplementedError
    end

    # overwrite this to provide a method for converting from a human readable format to a storage format.
    # this is good for letting people do fuzzy searches, or add values in a form a variety of ways, but still having consistent data.
    def from_human(value)
      raise MethodNotImplementedError
    end
  end
end