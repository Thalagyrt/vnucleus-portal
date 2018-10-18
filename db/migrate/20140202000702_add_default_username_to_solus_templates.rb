class AddDefaultUsernameToSolusTemplates < ActiveRecord::Migration
  def change
    add_column :solus_templates, :root_username, :string
  end
end
