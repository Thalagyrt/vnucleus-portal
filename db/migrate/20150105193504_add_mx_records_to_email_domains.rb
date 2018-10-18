class AddMxRecordsToEmailDomains < ActiveRecord::Migration
  def change
    add_column :email_domains, :mx_records, :string, array: true, default: "{}"
    add_column :email_domains, :mx_records_valid, :boolean, default: false
  end
end
