module Monitoring
  class NotificationTarget < ActiveRecord::Base
    extend Enumerize

    belongs_to :account, class_name: Accounts::Account

    validates :target_type, presence: true
    validates :target_value, presence: true
    validates :target_value, email: true, if: :is_email?

    enumerize :target_type, in: { email: 1, pagerduty: 2 }

    has_many :check_notification_targets
    has_many :checks, through: :check_notification_targets

    scope :find_verified, -> { where(target_verified: true) }

    before_save :assign_verification_code

    def is_email?
      target_type.to_sym == :email
    end

    def assign_verification_code
      self.verification_code ||= StringGenerator.long_id
    end
  end
end