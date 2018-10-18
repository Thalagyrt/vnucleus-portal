class IndexUserEmailConfirmed < ActiveRecord::Migration
  def change
    add_index :users_users, :email_confirmed
  end
end
