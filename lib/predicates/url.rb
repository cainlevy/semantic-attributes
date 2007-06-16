require 'uri'

# Defines a field as a URL.
# options:
#   :domains => [...] - a whitelist of allowed domains (e.g. ['com', 'net', 'org'])
#   :schemes = [...] - a whitelist of allowed schemes. default is ['http', 'https']
#   :ports = [...] - a whitelist of allowed ports. default is [80]
#   :allow_ip_address => boolean - whether to allow ip addresses in addition to domain names
#   :implied_scheme = string - what scheme to assume if non is present (default is 'http')
class Predicates::Url < Predicates::Base
  attr_accessor :domains
  attr_accessor :allow_ip_address
  attr_accessor :schemes
  attr_accessor :ports
  attr_accessor :implied_scheme

  def initialize(attr, options = {})
    defaults = {
      :allow_ip_address => true,
      :schemes => ['http', 'https'],
      :implied_scheme => 'http'
    }

    super attr, defaults.merge(options)
  end

  def error_message
    @error_message || '%s must be a valid URL.'
  end

  def validate(value, record)
    url = URI.parse(value)
    domain = url.host ? url.host.split('.').last : nil

    valid = true
    valid &&= (!self.schemes or self.schemes.include? url.scheme)
    valid &&= (!self.domains or self.domains.include? domain)
    valid &&= (!self.ports or self.ports.include? url.port)
    valid &&= (self.allow_ip_address or not url.host =~ /^([0-9]{1,3}\.){3}[0-9]{1,3}$/)

    valid
  rescue URI::InvalidURIError
    false
  end

  def to_human(v); v; end

  def from_human(v)
    url = URI.parse(v)
    url = URI.parse("#{self.implied_scheme}://#{v}") if self.implied_scheme and not (url.scheme and url.host)
    url.to_s
  rescue URI::InvalidURIError
    v
  end
end