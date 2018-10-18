class AddVirtualizationTypeToSolusTemplates < ActiveRecord::Migration
  def change
    add_column :solus_templates, :virtualization_type, :string
  end
end
