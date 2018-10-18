class RemoveUniqueTogetherIndexOnMailboxDomainAliases < ActiveRecord::Migration
  def change
    remove_index :email_mailboxes, [:domain_id, :alias]
  end
end
