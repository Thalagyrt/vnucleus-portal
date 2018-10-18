class AddAffinityGroupToSolusTemplates < ActiveRecord::Migration
  def change
    add_column :solus_templates, :affinity_group, :string
    add_index :solus_templates, :affinity_group
  end
end
