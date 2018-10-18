class AddWebmailUriToEmailDomains < ActiveRecord::Migration
  def change
    add_column :email_domains, :webmail_uri, :string
  end
end
