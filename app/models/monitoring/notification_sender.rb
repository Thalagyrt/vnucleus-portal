module Monitoring
  class NotificationSender
    def initialize(opts = {})
      @check = opts.fetch(:check)
      @staff_notification_sender = opts.fetch(:staff_notification_sender) { StaffNotificationSender.new(check: check) }
      @account_notification_sender = opts.fetch(:account_notification_sender) { AccountNotificationSender.new(check: check) }
      @notification_sender_class_finder = opts.fetch(:notification_sender_class_finder) { NotificationSenderClassFinder.new }
    end

    def send_notification
      staff_notification_sender.send_notification if notify_staff?
      account_notification_sender.send_notification if notify_account?

      verified_notification_targets.each do |target|
        notification_sender_class_finder.for_target(target).new(check: check, target_value: target.target_value).send_notification
      end
    end

    private
    attr_reader :check, :staff_notification_sender, :account_notification_sender, :notification_sender_class_finder
    delegate :notify_staff?, :notify_account?, :priority, :verified_notification_targets, to: :check
  end
end