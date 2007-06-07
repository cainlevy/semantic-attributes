# Blacklisted is the inverse of Enumerated
class Predicates::Blacklisted < Predicates::Enumerated
  def validate(*args)
    !super
  end
end