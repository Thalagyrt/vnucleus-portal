module Licenses
  class UsageReportDecorator < ApplicationDecorator
    delegate_all

    def to_s
      if object.end_date > Time.zone.today
        "#{object.to_s} (Current)"
      else
        object.to_s
      end
    end
  end
end