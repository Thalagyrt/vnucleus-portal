class AddGenerateRootPasswordToTemplates < ActiveRecord::Migration
  def change
    add_column :solus_templates, :generate_root_password, :boolean, default: false
  end
end
