# Marks an attribute as being required. This is really just a shortcut for using the or_empty? setting.
#
# Example:
#   class Comment < ActiveRecord::Base
#     has_one :owner
#     subject_is_required
#     owner_is_required
#   end
class Predicates::Required < Predicates::Base
  # this permanently sets :or_empty to false
  def allow_empty?
    false
  end

  def error_message
    @error_message || 'is required.'
  end

  def validate(value, record)
    !value.blank?
  end
end