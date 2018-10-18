class RenameAutocompleteParameterFetchToAutocompleteProvision < ActiveRecord::Migration
  def change
    rename_column :solus_templates, :autocomplete_parameter_fetch, :autocomplete_provision
  end
end
