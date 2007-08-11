# Marks an attribute as being an association. Has options for controlling how many associated objects there can be.
#
# You can require associations by name. Currently only works for singular associations (has_one, belongs_to).
#
# Example:
#   class Comment < ActiveRecord::Base
#     has_one :owner
#     owner_is_association :or_empty => true
#   end
class Predicates::Association < Predicates::Base
  # if there's a minimum to the number of associated records
  attr_accessor :min

  # if there's a maximum to the number of associated records
  attr_accessor :max

  def error_message
    @error_message || 'is required.'
  end

  def validate(value, record)
    # assume the best
    valid = true

    # we treat singular and plural the same
    associated = [value].flatten

    invalid_new_records = associated.select{|r| r.new_record?}.select do |new_record|
      unless recursion_stack.include? new_record
        recursion_stack << record
        v = !new_record.valid?
        recursion_stack.delete(record)
        v # return true if not valid
      end
    end

    # first, count how many records we expect to persist, then validate against min/max
    quantity = associated.length - invalid_new_records.length
    valid &&= (!min or quantity >= min)
    valid &&= (!max or quantity <= max)

    # if we can't allow empty associations, then we need to do an extra check: if these
    # records are new and invalid then they might not persist.
    valid &&= (allow_empty? or quantity > 0)

    valid
  end

  private

  cattr_accessor :recursion_stack
  @@recursion_stack = []
end