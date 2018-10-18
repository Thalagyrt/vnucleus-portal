class AddDefaultStatusCodeToChecks < ActiveRecord::Migration
  def change
    change_column :monitoring_checks, :status_code, :integer, default: 3
  end
end
