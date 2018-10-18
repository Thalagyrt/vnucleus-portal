class AddMinimumRamToSolusTemplates < ActiveRecord::Migration
  def change
    add_column :solus_templates, :minimum_ram, :bigint, default: 0
  end
end
