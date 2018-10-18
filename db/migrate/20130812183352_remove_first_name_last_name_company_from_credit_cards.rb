class RemoveFirstNameLastNameCompanyFromCreditCards < ActiveRecord::Migration
  def change
    remove_column :credit_cards, :first_name
    remove_column :credit_cards, :last_name
  end
end
