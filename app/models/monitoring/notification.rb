module Monitoring
  class Notification < ActiveRecord::Base
    extend Enumerize

    belongs_to :check

    enumerize :current_priority, in: { low: 1, high: 2 }, scope: true

    validates :target_type, presence: true
    validates :target_value, presence: true

    scope :find_active, -> { where(resolved_at: nil) }

    def self.current_for_target(target_type, target_value)
      where(target_type: target_type, target_value: target_value, resolved_at: nil).first
    end

    def resolve!
      update_attributes resolved_at: Time.zone.now
    end

    def resolved?
      resolved_at.present?
    end
  end
end