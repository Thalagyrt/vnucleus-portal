class AddSuspensionAndTerminationReasonsToMailboxes < ActiveRecord::Migration
  def change
    add_column :email_mailboxes, :suspension_reason, :string
    add_column :email_mailboxes, :termination_reason, :string
  end
end
