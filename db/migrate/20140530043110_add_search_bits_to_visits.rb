class AddSearchBitsToVisits < ActiveRecord::Migration
  def change
    add_column :visits, :utm_data, :string
    add_index :visits, :utm_data

    Visit.all.each(&:save!)
  end
end
