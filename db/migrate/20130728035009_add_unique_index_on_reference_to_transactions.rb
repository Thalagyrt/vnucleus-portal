class AddUniqueIndexOnReferenceToTransactions < ActiveRecord::Migration
  def change
    add_index :transactions, :reference, unique: true
  end
end
