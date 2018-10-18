class AddSrvRecordCorrectToEmailDomains < ActiveRecord::Migration
  def change
    add_column :email_domains, :srv_record_valid, :boolean, default: false
  end
end
