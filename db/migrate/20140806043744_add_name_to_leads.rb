class AddNameToLeads < ActiveRecord::Migration
  def change
    add_column :leads_leads, :first_name, :string
    add_column :leads_leads, :last_name, :string
  end
end
