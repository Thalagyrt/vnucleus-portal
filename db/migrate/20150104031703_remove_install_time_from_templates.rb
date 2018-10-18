class RemoveInstallTimeFromTemplates < ActiveRecord::Migration
  def change
    remove_column :solus_templates, :install_time
    remove_column :solus_templates, :install_count
  end
end
