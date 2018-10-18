class AddMaskedNumberToCreditCards < ActiveRecord::Migration
  def change
    add_column :credit_cards, :masked_number, :string
  end
end
