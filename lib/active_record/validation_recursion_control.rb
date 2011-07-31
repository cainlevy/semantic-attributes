module ActiveRecord #:nodoc:
module ValidationRecursionControl #:nodoc:
  def self.included(base)
    base.class_eval do
      alias_method_chain :valid?, :recursion_control
    end
  end

  # It's easy to break out of circular validation dependencies. All we need to do
  # is suppose that if a record's validity depends in some way on itself, then we
  # can assume that circular condition is satisfied. That assumption will change
  # nothing about the actual validity of the record.
  def valid_with_recursion_control?(*args, &block)
    assumed_valid? or with_recursion_control do valid_without_recursion_control?(*args, &block) end
  end

  private

  mattr_accessor :recursion_stack
  @@recursion_stack = []

  def assumed_valid?
    recursion_stack.include? self
  end

  def with_recursion_control(&block)
    recursion_stack << self
    result = yield
    recursion_stack.delete(self)
    result
  end
end
end
