require 'uri'

# Defines a field as a simple domain (not URL).
class Predicates::Domain < Predicates::Base
  def error_message
    @error_message || "must be a simple domain."
  end

  def validate(value, record)
    url = URI.parse(with_protocol(value))
    valid = (url.host == value)
    valid &&= (value.match /\..+\Z/) # to catch "http://example" or similar
    valid &&= (!value.match /^([0-9]{1,3}\.){3}[0-9]{1,3}$/) # to catch ip addresses

    valid
  rescue URI::InvalidURIError
    false
  end

  def from_human(v)
    URI.parse(with_protocol(v)).host || v
  rescue URI::InvalidURIError
    v
  end

  protected

  def with_protocol(value)
    !value or value.include?("://") ? value : "http://#{value}"
  end
end