class CreateUsersProfileChanges < ActiveRecord::Migration
  def change
    create_table :users_profile_changes do |t|
      t.integer :user_id
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :security_question
      t.string :security_answer
      t.datetime :created_at
    end

    add_index :users_profile_changes, :user_id
    add_index :users_profile_changes, :email
    add_index :users_profile_changes, :created_at
  end
end
