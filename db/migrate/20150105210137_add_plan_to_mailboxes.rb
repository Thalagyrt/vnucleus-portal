class AddPlanToMailboxes < ActiveRecord::Migration
  def change
    add_column :email_mailboxes, :plan_id, :integer
    add_index :email_mailboxes, :plan_id
  end
end
