class AddContactInfoToUser < ActiveRecord::Migration
  def change
    add_column :users, :address_line1, :string
    add_column :users, :address_line2, :string
    add_column :users, :address_city, :string
    add_column :users, :address_state, :string
    add_column :users, :address_zip, :string
    add_column :users, :address_country, :string
    add_column :users, :phone, :string
  end
end
