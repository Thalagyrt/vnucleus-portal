class AddAutomationDatesToMailboxes < ActiveRecord::Migration
  def change
    add_column :email_mailboxes, :suspend_at, :datetime
    add_column :email_mailboxes, :terminate_at, :datetime

    add_index :email_mailboxes, :suspend_at
    add_index :email_mailboxes, :terminate_at
  end
end
