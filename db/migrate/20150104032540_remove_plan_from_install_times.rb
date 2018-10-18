class RemovePlanFromInstallTimes < ActiveRecord::Migration
  def change
    remove_column :solus_install_times, :plan_id
  end
end
