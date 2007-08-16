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

    # This extra check is in case we recursed back by some other mechanism.
    # For example, ActiveRecord will automatically validate *new* records in a plural
    # association (e.g. has_many). So, suppose the following setup:
    #
    #   Book
    #     belongs_to :author
    #     author_is_association :or_empty => false
    #   end
    #
    #   Author
    #     has_many :books
    #   end
    #
    #   a = Author.new
    #   a.books.create :author => a
    #   a.save
    #
    # The ":author => a" setting, while duplicating some of the functionality of
    # a.books.create, is done to satisfy the book's author requirement. Without it the
    # book would not validate at all. But with it, there's a chance of an infinite loop.
    #
    # So what happens? During `a.save`, ActiveRecord tries to validate the new book
    # (simply because it's a new record in a plural association collection), and the new
    # book then tries to validate the new author. Since ActiveRecord doesn't have any
    # recursion control for this kind of thing (understandable, since this only happens for
    # plural associations) it validates the new author by returning directly to the new book.
    # And voila, we're looping. But this next line stops it from going further, even if
    # it's a little late.
    #
    # Why bother with recursion control? Why not just tell the programmer to rework the
    # code? Because we can deal with it. Why impose constraints on the programmer if we
    # can easily deal with it?
    return valid if recursion_stack.include? record

    # we treat singular and plural the same
    associated = [value].flatten
    invalid_new_records = associated.select{|r| r.new_record?}.select do |new_record|
      # if we're not coming *from* the new_record
      unless recursion_stack.include? new_record
        # add *this* record to the recursion stack to make sure we don't come back
        recursion_stack << record
        v = new_record.valid?
        recursion_stack.delete(record)
        !v # return true if not valid
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