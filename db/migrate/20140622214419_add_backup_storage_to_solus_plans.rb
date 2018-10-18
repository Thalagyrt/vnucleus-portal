class AddBackupStorageToSolusPlans < ActiveRecord::Migration
  def change
    add_column :solus_plans, :backup_disk, :bigint
  end
end
