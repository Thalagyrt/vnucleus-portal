class AddProfileInfoToMailboxes < ActiveRecord::Migration
  def change
    add_column :email_mailboxes, :first_name, :string
    add_column :email_mailboxes, :last_name, :string
    add_column :email_mailboxes, :display_name, :string
  end
end
