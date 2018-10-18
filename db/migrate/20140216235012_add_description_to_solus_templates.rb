class AddDescriptionToSolusTemplates < ActiveRecord::Migration
  def change
    add_column :solus_templates, :description, :string
  end
end
