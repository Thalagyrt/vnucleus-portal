class AddCheckCachesToChecks < ActiveRecord::Migration
  def change
    add_column :monitoring_checks, :test_to_s, :string
    add_column :monitoring_checks, :successful, :boolean, default: false
  end
end
