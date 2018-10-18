module Monitoring
  class PerformanceMetric < ActiveRecord::Base
    belongs_to :result

    validates :result, presence: true
    validates :key, presence: true
    validates :value, presence: true
  end
end