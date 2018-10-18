module Monitoring
  class Result < ActiveRecord::Base
    extend Enumerize

    belongs_to :check
    has_many :performance_metrics, dependent: :delete_all

    validates :check, presence: true
    validates :response_time, presence: true
    validates :status_code, presence: true

    enumerize :status_code, in: { ok: 0, warning: 1, critical: 2 }

    scope :sorted, -> { order(created_at: :desc) }

    def successful?
      status_code.to_sym == :ok
    end
  end
end