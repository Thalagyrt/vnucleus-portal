class AddCardholderNameToCreditCards < ActiveRecord::Migration
  def change
    add_column :credit_cards, :cardholder_name, :string
  end
end
