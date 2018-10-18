class AddMuzzleUntilToMonitoringChecks < ActiveRecord::Migration
  def change
    add_column :monitoring_checks, :muzzle_until, :datetime
    add_index :monitoring_checks, :muzzle_until
  end
end
