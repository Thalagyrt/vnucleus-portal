class ShiftLicenseUsagesBackToCorrectMonths < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        execute "UPDATE licenses_usages SET created_at=created_at - interval '1 month'"
      end

      dir.down do
        execute "UPDATE licenses_usages SET created_at=created_at + interval '1 month'"
      end
    end
  end
end
