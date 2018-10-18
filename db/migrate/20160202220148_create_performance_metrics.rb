class CreatePerformanceMetrics < ActiveRecord::Migration
  class Result < ActiveRecord::Base
    self.table_name = 'monitoring_results'

    has_many :performance_metrics

    serialize :performance_data

    scope :with_performance_data, -> { where.not(performance_data: nil) }
  end

  class PerformanceMetric < ActiveRecord::Base
    self.table_name = 'monitoring_performance_metrics'

    belongs_to :result
  end

  def change
    create_table :monitoring_performance_metrics do |t|
      t.integer :result_id, null: false
      t.string :key, null: false
      t.decimal :value, null: false
      t.decimal :warn, default: 0
      t.decimal :crit, default: 0
      t.decimal :min, default: 0
      t.decimal :max, default: 0
    end

    add_index :monitoring_performance_metrics, :result_id
    add_index :monitoring_performance_metrics, :key

    Result.with_performance_data.find_each do |result|
      puts "Converting #{result.id}..."

      result.performance_data.each do |key, value|
        result.performance_metrics.create!(
          key: key, value: value[:value], warn: value[:warn], crit: value[:crit], min: value[:min], max: value[:max]
        )
      end
    end
  end
end
