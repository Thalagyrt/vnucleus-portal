class RemoveWebmailUriFromDomains < ActiveRecord::Migration
  def change
    remove_column :email_domains, :webmail_uri
  end
end
