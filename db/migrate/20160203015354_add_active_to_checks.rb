class AddActiveToChecks < ActiveRecord::Migration
  def change
    add_column :monitoring_checks, :enabled, :boolean, default: true
    add_index :monitoring_checks, :enabled
  end
end
