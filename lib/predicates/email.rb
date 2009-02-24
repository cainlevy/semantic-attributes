# Describes a regular expression pattern for email addresses, based on RFC2822 and RFC3696.
# Adapted from Alex Dunae's validates_email_format_of plugin v1.2.2, available under MIT License at http://code.dunae.ca/validates_email_format_of.html
#
# ==Options
# * :with_mx_record [boolean, default false] - whether to verify the email's domain using a dns lookup for an mx record. This requires the Unix `dig` command. In Debian this is part of the dnsutils package. NOTE: RFC2821 states that when no MX records are listed, an A record may be used instead. This means that a missing MX record may not mean an invalid email address! Use at your own risk.
#
# == Example
#   field_is_an_email :with_mx_record => true
class Predicates::Email < Predicates::Base
  attr_accessor :with_mx_record

  def validate(value, record)
    # local part max is 64 chars, domain part max is 255 chars
    domain, local = value.reverse.split('@', 2)

    valid = value.match(EmailAddressPattern)
    valid &&= !(value.match /\.\./)
    valid &&= (domain.length <= 255)
    valid &&= (local.length <= 64)

    if valid and self.with_mx_record
      mx_record = `dig #{value.split('@').last} mx +noall +short`
      valid &&= (!mx_record.empty?)
    end

    valid
  end

  def error_message
    @error_message || :email
  end

  EmailAddressPattern = begin
    local_part_special_chars = Regexp.escape('!#$%&\'*-/=?+-^_`{|}~')
    local_part_unquoted = '(([[:alnum:]' + local_part_special_chars + ']+[\.\+]+))*[[:alnum:]' + local_part_special_chars + '+]+'
    local_part_quoted = '\"(([[:alnum:]' + local_part_special_chars + '\.\+]*|(\\\\[\x00-\xFF]))*)\"'
    Regexp.new(
      '^((' + local_part_unquoted + ')|(' + local_part_quoted + ')+)@(((\w+\-+)|(\w+\.))*\w{1,63}\.[a-z]{2,6}$)',
      Regexp::EXTENDED | Regexp::IGNORECASE
    )
  end
end
