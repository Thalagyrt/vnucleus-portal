class AddDomainNamesToEmailMailboxes < ActiveRecord::Migration
  def change
    add_column :email_mailboxes, :domain_name, :string

    Email::Mailbox.find_each do |mailbox|
      mailbox.update_attributes domain_name: mailbox.domain.domain_name
    end
  end
end
