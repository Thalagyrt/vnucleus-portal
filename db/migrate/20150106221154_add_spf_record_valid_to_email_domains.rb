class AddSpfRecordValidToEmailDomains < ActiveRecord::Migration
  def change
    add_column :email_domains, :spf_record_valid, :boolean, default: false
  end
end
