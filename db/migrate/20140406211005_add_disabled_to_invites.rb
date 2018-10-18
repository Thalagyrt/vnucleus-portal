class AddDisabledToInvites < ActiveRecord::Migration
  def change
    add_column :accounts_invites, :disabled, :boolean
  end
end
