class AddInstallTimeToSolusTemplates < ActiveRecord::Migration
  def change
    add_column :solus_templates, :install_time, :integer, default: 0
  end
end
