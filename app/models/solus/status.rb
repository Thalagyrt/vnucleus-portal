module Solus
  class Status
    include ActiveModel::Model
    include Draper::Decoratable

    attr_accessor :ip_addresses, :power_state, :total_transfer, :used_transfer, :total_disk, :node, :xen_id

    def online?
      power_state == 'online'
    end

    def offline?
      power_state == 'offline'
    end
  end
end