class RenameTestType < ActiveRecord::Migration
  def change
    rename_column :monitoring_checks, :test_type, :check_type
  end
end
