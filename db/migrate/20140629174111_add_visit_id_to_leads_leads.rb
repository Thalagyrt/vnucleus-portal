class AddVisitIdToLeadsLeads < ActiveRecord::Migration
  def change
    add_column :leads_leads, :visit_id, :integer
  end
end
