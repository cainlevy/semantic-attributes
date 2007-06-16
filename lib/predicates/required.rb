# you can require associations. the only caveat is that you can't require an association in both directions, because when the associated is a new record it can't validate the original record (no foreign key to load association) and when the associated is not a new record there's a risk of infinite looping.
# 
## needs: automatic handling of associated (and valid status of associated)
#  - if attribute is an association column, then validate presence of (by checking for an id OR an instantiated object)
#  - if associated is a new_record, then validate the associated record itself (predict success of saving)
#  - - watch out for infinite loops!
class Predicates::Required < Predicates::Base
  def error_message
    @error_message || '%s is required.'
  end

  def validate(value, record)
    valid = true
    if value.kind_of?(ActiveRecord::Base) and value.new_record?
      valid &&= value.valid?
    else
      valid &&= (!value.nil?)
      valid &&= !(value.respond_to?(:empty?) and value.empty?)
    end
    valid
  end

  def to_human(v); v; end
  def from_human(v); v; end
end