# needs: option for how to handle empty string (by default, empty string fails validation)
# needs: automatic handling of associated (and valid status of associated)
#  - if attribute is an association column, then validate presence of (by checking for an id OR an instantiated object)
#  - if associated is a new_record, then validate the associated record itself (predict success of saving)
class Predicates::Required < Predicates::Base
end