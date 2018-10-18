class AddLongIdToMonitoringChecks < ActiveRecord::Migration
  def change
    add_column :monitoring_checks, :long_id, :string
    add_index :monitoring_checks, :long_id, unique: true

    reversible do |dir|
      dir.up do
        Monitoring::Check.find_each do |check|
          loop do
            check.long_id = StringGenerator.long_id
            break unless Monitoring::Check.exists?(long_id: check.long_id)
          end
          check.save!
        end
      end
    end
  end
end
