class AddMetadataToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :metadata, :text
  end
end
