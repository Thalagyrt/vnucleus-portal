class CreateLeads < ActiveRecord::Migration
  def change
    create_table :leads_leads do |t|
      t.string :email
      t.text :body
      t.datetime :created_at
    end

    add_index :leads_leads, :created_at
  end
end
