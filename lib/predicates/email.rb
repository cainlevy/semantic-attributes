# Describes a regular expression pattern for email addresses, using RFC822.
#
# ==Options
# * :with_mx_record [boolean, default false] - whether to verify the email's domain using a dns lookup for an mx record. This requires the Unix `dig` command. In Debian this is part of the dnsutils package.
#
# == Example
#   field_is_an_email :with_mx_record => true
class Predicates::Email < Predicates::Pattern
  attr_accessor :with_mx_record
  def like
    @like ||= Predicates::Email::RFC822::EmailAddress
  end

  def validate(value, record)
    result = super
    if result and self.with_mx_record
      domain = value.split('@').last
      mx_record = `dig #{domain} mx +noall +short`
      result &&= (!mx_record.empty?)
    end
    result
  end

  def error_message
    @error_message || 'must be an email address.'
  end

  #
  # RFC822 Email Address Regex
  # --------------------------
  #
  # Originally written by Cal Henderson
  # c.f. http://iamcal.com/publish/articles/php/parsing_email/
  #
  # Translated to Ruby by Tim Fletcher, with changes suggested by Dan Kubb.
  #
  # Licensed under a Creative Commons Attribution-ShareAlike 2.5 License
  # http://creativecommons.org/licenses/by-sa/2.5/
  #
  module RFC822
    EmailAddress = begin
      qtext = '[^\\x0d\\x22\\x5c\\x80-\\xff]'
      dtext = '[^\\x0d\\x5b-\\x5d\\x80-\\xff]'
      atom = '[^\\x00-\\x20\\x22\\x28\\x29\\x2c\\x2e\\x3a-\\x3c\\x3e\\x40\\x5b-\\x5d\\x7f-\\xff]+'
      quoted_pair = '\\x5c[\\x00-\\x7f]'
      domain_literal = "\\x5b(?:#{dtext}|#{quoted_pair})*\\x5d"
      quoted_string = "\\x22(?:#{qtext}|#{quoted_pair})*\\x22"
      domain_ref = atom
      sub_domain = "(?:#{domain_ref}|#{domain_literal})"
      word = "(?:#{atom}|#{quoted_string})"
      domain = "#{sub_domain}(?:\\x2e#{sub_domain})+" # edited to require a TLD
      local_part = "#{word}(?:\\x2e#{word})*"
      addr_spec = "#{local_part}\\x40#{domain}"
      pattern = /\A#{addr_spec}\z/
    end
  end
end