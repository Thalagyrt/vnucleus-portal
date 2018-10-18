module Monitoring
  class Muzzle
    OPTIONS = {
        '5 Minutes' => 300,
        '15 Minutes' => 900,
        '30 Minutes' => 1800,
        '1 Hour' => 3600,
        '4 Hours' => 14400,
        '8 Hours' => 28800,
        '24 Hours' => 86400,
        'Unmuzzle' => 0,
    }

    include ActiveModel::Model

    def duration=(value)
      @duration = value.to_i
    end

    attr_reader :duration

    validates :duration, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  end
end