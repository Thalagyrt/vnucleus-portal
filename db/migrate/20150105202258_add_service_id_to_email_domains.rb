class AddServiceIdToEmailDomains < ActiveRecord::Migration
  def change
    add_column :email_domains, :service_id, :integer
    add_index :email_domains, :service_id
  end
end
