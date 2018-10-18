module Licenses
  class Usage < ActiveRecord::Base
    belongs_to :product, inverse_of: :usages
    belongs_to :account, class_name: Accounts::Account

    def self.for_month(reference_date)
      where('created_at >= ? and created_at < ?', reference_date.at_beginning_of_month, (reference_date + 1.month).at_beginning_of_month)
    end

    def self.available_reference_dates
      pluck("date_trunc('month', created_at) as created_at").uniq.map(&:to_date).sort.reverse
    end
  end
end