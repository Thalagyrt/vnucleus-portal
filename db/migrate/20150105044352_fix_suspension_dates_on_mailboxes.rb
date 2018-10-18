class FixSuspensionDatesOnMailboxes < ActiveRecord::Migration
  def change
    remove_column :email_mailboxes, :suspend_at
    remove_column :email_mailboxes, :terminate_at

    add_column :email_mailboxes, :suspend_on, :date
    add_column :email_mailboxes, :terminate_on, :date

    add_index :email_mailboxes, :suspend_on
    add_index :email_mailboxes, :terminate_on
  end
end
