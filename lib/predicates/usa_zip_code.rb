# A United States zip code.
# Only validates format, does not attempt any verification for *actual* zip codes.
# Validates via regular expression.
#
# ==Options
# * :extended [boolean, default false] - whether to allow the extended (+4) zip code format
class Predicates::UsaZipCode < Predicates::Pattern
  attr_writer :extended
  def extended?
    @extended ? true : false
  end

  def like
    @like ||= /\A[0-9]{5}#{'(-[0-9]{4})?' if extended?}\Z/
  end
  undef_method :like=

  def error_message
    @error_message || 'must be a US zip code.'
  end
end