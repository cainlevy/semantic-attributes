# Marks an attribute as being an association. Has options for controlling how many associated objects there can be.
#
# You can require associations by name.
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
    @error_message || :required
  end

  def validate(value, record)
    # we treat singular and plural the same
    associated = [value].flatten

    # we need to check the validity of new records in order to calculate how many
    # will save properly. this lets us validate against the min/max parameters.
    invalid_new_records = associated.select{|r| r.new_record? and not r.valid?}
    valid_new_records = associated - invalid_new_records

    valid = true

    # then validate against min/max
    quantity = valid_new_records.length
    valid &&= (!min or quantity >= min)
    valid &&= (!max or quantity <= max)

    # if we can't allow empty associations, then we need to do an extra check: if these
    # records are new and invalid then they might not persist.
    valid &&= (allow_empty? or quantity > 0)

    valid
  end
end
