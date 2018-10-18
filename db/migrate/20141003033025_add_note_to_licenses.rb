class AddNoteToLicenses < ActiveRecord::Migration
  def change
    add_column :licenses_licenses, :note, :string
  end
end
