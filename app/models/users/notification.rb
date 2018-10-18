module Users
  class Notification < ActiveRecord::Base
    belongs_to :user, inverse_of: :notifications
    belongs_to :actor, class_name: ::Users::User
    belongs_to :target, polymorphic: true

    validates :user, presence: true

    validates :link_policy, inclusion: { in: ['users', 'admin'] }

    scope :find_unread, -> { where.not(read: true) }
    scope :find_recent, -> { where('created_at >= ?', Rails.application.config.notification_cutoff.ago) }
    scope :find_expired, -> { where('created_at < ?', Rails.application.config.notification_cutoff.ago) }
    scope :sorted, -> { order('created_at DESC') }

    def mark_read
      update_attributes read: true
    end

    def self.mark_all_read
      update_all(read: true)
    end

    def self.unread_count
      find_unread.count
    end

    def self.clean_up
      find_expired.delete_all
    end
  end
end