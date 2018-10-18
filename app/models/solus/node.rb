module Solus
  class Node < ActiveRecord::Base
    has_many :servers, inverse_of: :node
    has_many :usages, inverse_of: :node
    belongs_to :cluster

    before_save :update_available_ram

    scope :unlocked, -> { where.not(locked: true) }

    def to_s
      "#{name} (#{id})"
    end

    def stock(plan)
      return 0 if locked?

      [
          available_ram / plan.ram,
          available_disk / plan.disk,
          available_ipv4 / plan.ip_addresses,
          available_ipv6 / plan.ipv6_addresses
      ].min
    end

    private
    def update_available_ram
      self.ram_limit ||= 0
      self.allocated_ram ||= 0
      self.available_ram = [0, ram_limit - allocated_ram].max
    end
  end
end