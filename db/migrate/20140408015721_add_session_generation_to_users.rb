class AddSessionGenerationToUsers < ActiveRecord::Migration
  def change
    add_column :users_users, :session_generation, :datetime
  end
end
