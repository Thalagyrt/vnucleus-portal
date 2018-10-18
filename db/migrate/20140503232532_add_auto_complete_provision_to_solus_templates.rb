class AddAutoCompleteProvisionToSolusTemplates < ActiveRecord::Migration
  def change
    add_column :solus_templates, :autocomplete_parameter_fetch, :boolean

    reversible do |dir|
      dir.up do
        execute "UPDATE solus_templates SET autocomplete_parameter_fetch='t'"
      end
    end
  end
end
