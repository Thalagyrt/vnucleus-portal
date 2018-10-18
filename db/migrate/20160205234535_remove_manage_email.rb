class RemoveManageEmail < ActiveRecord::Migration
  def change
    execute 'UPDATE accounts_memberships SET roles_mask=roles_mask & 7'
  end
end
