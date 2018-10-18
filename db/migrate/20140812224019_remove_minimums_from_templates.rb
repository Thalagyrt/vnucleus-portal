class RemoveMinimumsFromTemplates < ActiveRecord::Migration
  def change
    remove_column :solus_templates, :minimum_ram
    remove_column :solus_templates, :minimum_disk
  end
end
