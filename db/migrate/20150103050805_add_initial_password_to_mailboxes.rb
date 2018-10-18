class AddInitialPasswordToMailboxes < ActiveRecord::Migration
  def change
    add_column :email_mailboxes, :initial_password, :string

    Email::Mailbox.find_each do |mailbox|
      mailbox.initial_password = StringGenerator.password
      mailbox.save!
    end
  end
end
