class AddSpfRecordsToServices < ActiveRecord::Migration
  def change
    add_column :email_services, :spf_records, :text
  end
end
