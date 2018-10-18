class AddMaximumMailboxCountToEmailDomains < ActiveRecord::Migration
  def change
    add_column :email_domains, :maximum_mailbox_count, :integer, default: 0
  end
end
