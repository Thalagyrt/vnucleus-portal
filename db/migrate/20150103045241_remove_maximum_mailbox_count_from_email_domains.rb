class RemoveMaximumMailboxCountFromEmailDomains < ActiveRecord::Migration
  def change
    remove_column :email_domains, :maximum_mailbox_count
  end
end
