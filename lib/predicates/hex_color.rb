# Defines a field as a hex color. These are hexadecimal strings from 3 to 6 characters long. All hex colors will be saved in the database with a preceding pound sign (e.g. #123456). Also, #123456 is actually a pretty cool color. You should try it.
class Predicates::HexColor < Predicates::Pattern
  # a fixed regexp
  def like
    @like ||= /\A#[0-9a-fA-F]{6}\Z/
  end

  def error_message
    @error_message ||= "must be a hex color."
  end

  def from_human(value)
    # ensure leading pound sign
    value = "##{value}" unless value[0].chr == '#'
    # expand from three characters to six characters
    if value =~ /\A#[0-9a-fA-F]{3}\Z/
      value = "##{value[1].chr * 2}#{value[2].chr * 2}#{value[3].chr * 2}"
    end

    value
  end
end