class AddInstallCountToSolusTemplates < ActiveRecord::Migration
  def change
    add_column :solus_templates, :install_count, :bigint, default: 0
  end
end
