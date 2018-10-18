class AddIsCPanelToSolusTemplates < ActiveRecord::Migration
  def change
    add_column :solus_templates, :category, :integer, default: 1
  end
end
