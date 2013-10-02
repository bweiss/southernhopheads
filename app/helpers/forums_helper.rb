module ForumsHelper
  def simple_age(time)
    foo = TimeDifference.between(time, Time.zone.now).in_general.select { |k, v| v > 0 }.first
    @simple_age = "#{foo[1]} #{foo[0]}"
    return @simple_age
  end
end
