class Prorater
  attr_reader :to, :from, :days

  def initialize(to, from = nil, days = 30.5)
    @to = to.in_time_zone(Time.zone)
    @from = from || Time.zone.now
    @days = days
  end

  def prorate(amount)
    (proration_factor * amount).round(0)
  end

  private
  def proration_factor
    (date_difference / days).to_f
  end

  def date_difference
    (to - from) / 1.day
  end
end