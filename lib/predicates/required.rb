# needs: automatic handling of associated (and valid status of associated)
#  - if attribute is an association column, then validate presence of (by checking for an id OR an instantiated object)
#  - if associated is a new_record, then validate the associated record itself (predict success of saving)
class Predicates::Required < Predicates::Base
  def error_message
    @error_message || '%s is required.'
  end

  def validate(value, record)
    !(value.nil? or (value.respond_to?(:empty?) and value.empty?))
  end

  def to_human(v); v; end
  def from_human(v); v; end
end