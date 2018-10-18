class AddCategoryToAccountEvents < ActiveRecord::Migration
  def change
    add_column :account_events, :category, :string
    add_index :account_events, :category
  end
end
