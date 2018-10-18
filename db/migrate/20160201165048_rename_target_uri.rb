class RenameTargetUri < ActiveRecord::Migration
  def change
    rename_column :monitoring_checks, :target_uri, :check_data
  end
end
