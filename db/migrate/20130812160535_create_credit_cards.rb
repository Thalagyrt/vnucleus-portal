class CreateCreditCards < ActiveRecord::Migration
  def change
    create_table :credit_cards do |t|
      t.integer :account_id
      t.string :braintree_customer
      t.date :expiration_date
      t.string :first_name
      t.string :last_name
      t.string :street_address
      t.string :extended_address
      t.string :locality
      t.string :region
      t.string :postal_code
      t.string :country_code_alpha3
    end

    add_index :credit_cards, :account_id
    add_index :credit_cards, :expiration_date
  end
end
