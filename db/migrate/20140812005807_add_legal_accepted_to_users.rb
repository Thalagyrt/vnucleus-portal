class AddLegalAcceptedToUsers < ActiveRecord::Migration
  def change
    add_column :users_users, :legal_accepted, :boolean, default: false
    Users::User.update_all legal_accepted: true
  end
end
