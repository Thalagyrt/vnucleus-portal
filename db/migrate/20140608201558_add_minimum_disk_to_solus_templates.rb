class AddMinimumDiskToSolusTemplates < ActiveRecord::Migration
  def change
    add_column :solus_templates, :minimum_disk, :bigint, default: 0
  end
end
