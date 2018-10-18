class AddFullNameToUsers < ActiveRecord::Migration
  def change
    add_column :users_users, :full_name, :string

    Users::User.all.each { |u| u.save!(validate: false) }
  end
end
