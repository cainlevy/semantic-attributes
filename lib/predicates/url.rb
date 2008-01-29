require 'uri'

# Defines a field as a URL.
#
# ==Options
#   :domains [array, default nil] - a whitelist of allowed domains (e.g. ['com', 'net', 'org']). set to nil to allow all domains.
#   :schemes [array, default ['http', 'https']] - a whitelist of allowed schemes. set to nil to allow all schemes.
#   :ports [array, default nil] - a whitelist of allowed ports. set to nil to allow all ports.
#   :allow_ip_address [boolean, default true] - whether to allow ip addresses instead to domain names.
#   :implied_scheme [string, symbol, default 'http'] - what scheme to assume if non is present.
#
# ==Examples
#   # if you need an ftp url
#   field_is_an_url :schemes => ['ftp']
#
#   # if you want to require https
#   field_is_an_url :schemes => ['https'], :implied_scheme => 'https', :ports => [443]
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
    @error_message || 'must be a valid URL.'
  end

  def validate(value, record)
    url = URI.parse(value)
    tld = (url.host && url.host.match(/\..+\Z/)) ? url.host.split('.').last : nil

    valid = true
    valid &&= (!tld.blank?)
    valid &&= (!self.schemes or self.schemes.include? url.scheme)
    valid &&= (!self.domains or self.domains.include? tld)
    valid &&= (!self.ports or self.ports.include? url.port)
    valid &&= (self.allow_ip_address or not url.host =~ /^([0-9]{1,3}\.){3}[0-9]{1,3}$/)

    valid
  rescue URI::InvalidURIError
    false
  end

  def from_human(v)
    url = URI.parse(v)
    url = URI.parse("#{self.implied_scheme}://#{v}") if self.implied_scheme and not (url.scheme and url.host)
    url.to_s
  rescue URI::InvalidURIError
    v
  end
end