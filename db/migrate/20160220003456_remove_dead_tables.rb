class RemoveDeadTables < ActiveRecord::Migration
  def change
    drop_table :email_aliases
    drop_table :email_domains
    drop_table :email_mailboxes
    drop_table :email_plans
    drop_table :email_usages

  end
end
