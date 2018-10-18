class AdjustNotifications < ActiveRecord::Migration
  def change
    remove_column :monitoring_notifications, :notification_target_id
    remove_column :monitoring_notifications, :sent_at
  end
end
