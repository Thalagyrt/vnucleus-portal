class AddPreseedBodyToSolusTemplates < ActiveRecord::Migration
  def change
    add_column :solus_templates, :preseed_template, :text
  end
end
