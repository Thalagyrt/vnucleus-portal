class ChangeToStateOnInvites < ActiveRecord::Migration
  def change
    add_column :accounts_invites, :state, :string
    remove_column :accounts_invites, :disabled

    add_index :accounts_invites, :state
  end
end
