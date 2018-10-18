class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :friendly_name
      t.string :state

      t.datetime :created_at
    end
  end
end
