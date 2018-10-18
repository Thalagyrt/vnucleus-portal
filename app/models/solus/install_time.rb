module Solus
  class InstallTime < ActiveRecord::Base
    belongs_to :template, inverse_of: :install_times

    validates :install_time, numericality: { greater_than_or_equal_to: 0 }
    validates :template, presence: true

    def self.log_install_time(install_time)
      create!(install_time: install_time)
    end

    def self.install_time
      values = order('created_at desc').limit(5).pluck(:install_time)

      if values.count > 0
        values.sum / values.count
      else
        0
      end
    end
  end
end