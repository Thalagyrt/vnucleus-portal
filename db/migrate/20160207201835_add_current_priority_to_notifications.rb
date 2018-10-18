class AddCurrentPriorityToNotifications < ActiveRecord::Migration
  def change
    add_column :monitoring_notifications, :current_priority, :integer, default: 2
  end
end
