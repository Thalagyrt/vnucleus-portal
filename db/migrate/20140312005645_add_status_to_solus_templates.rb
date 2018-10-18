class AddStatusToSolusTemplates < ActiveRecord::Migration
  def change
    add_column :solus_templates, :status, :integer
    add_index :solus_templates, :status
    execute 'UPDATE solus_templates SET status=1'
  end
end
