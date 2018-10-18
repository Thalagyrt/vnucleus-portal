class AddDeletedToMonitoringChecks < ActiveRecord::Migration
  def change
    add_column :monitoring_checks, :deleted, :boolean, default: false, null: false
    add_index :monitoring_checks, :deleted
  end
end
