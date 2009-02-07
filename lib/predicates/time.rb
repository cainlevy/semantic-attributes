# Describes a field as a Time field. Currently this means that it has both a time and a date.
#
# ==Options
# * :before [time] - specifies that the value must predate the given time (as object or string)
# * :after [time] - specifies that the value must postdate the given time (as object or string)
# * :distance [range] - specifies a range of seconds that provide an minimum and maximum time value to be calculated from the current time.
class Predicates::Time < Predicates::Base
  # specifies a time that must postdate any valid value
  def before=(val)
    @before = val.is_a?(Time) ? val : Time.parse(val)
  end
  attr_reader :before

  # specifies a time that must predate any valid value
  def after=(val)
    @after = val.is_a?(Time) ? val : Time.parse(val)
  end
  attr_reader :after
  
  # specifies a range of seconds where the lower boundary
  # is the minimum time value and the upper boundary is the
  # maximum time value, both interpreted from the current
  # time.
  attr_accessor :distance

  def error_message
    @error_message || "must be a point in time."
  end

  def validate(value, record)
    valid = value.is_a? Time
    valid &&= (value < self.before) if self.before
    valid &&= (value > self.after) if self.after
    
    if self.distance
      now = Time.now.utc
      valid &&= (value >= now + self.distance.begin)
      valid &&= (value <= now + self.distance.end)
    end

    valid
  end
end
