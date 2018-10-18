class CreateEmailPlans < ActiveRecord::Migration
  def change
    create_table :email_plans do |t|
      t.string :name
      t.integer :storage, limit: 8
      t.integer :service_id
    end

    add_index :email_plans, :service_id
  end
end
