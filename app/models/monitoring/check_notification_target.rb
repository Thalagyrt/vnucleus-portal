module Monitoring
  class CheckNotificationTarget < ActiveRecord::Base
    belongs_to :check
    belongs_to :notification_target

    validates :check, presence: true
    validates :notification_target, presence: true
  end
end