# A United States zip code.
# Only validates format, does not attempt any verification for *actual* zip codes.
# Validates via regular expression.
#
# ==Options
# * :extended [:allowed, :required, or false (default)] - whether to allow (or require!) the extended (+4) zip code format
class Predicates::UsaZipCode < Predicates::Pattern
  attr_accessor :extended

  def like
    return @like unless @like.nil?
    pattern = '[0-9]{5}'
    if extended
      pattern += '(-[0-9]{4})'
      pattern += '?' unless extended == :required
    end

    @like = /\A#{pattern}\Z/
  end
  undef_method :like=

  def error_message
    @error_message || :us_zip_code
  end
end
