module Solus
  class FirewallRulesController < ApplicationController
    def show
      @server = Solus::Server.find_current.find_by_xen_id!(params[:id])

      render json: {
                 allowed_ipv4: @server.ipv4_address_list,
                 allowed_ipv6: @server.ipv6_address_list,
                 enable_smtp: @server.enable_smtp,
                 synchronized: @server.synchronized?,
                 bypass_firewall: @server.bypass_firewall,
             }
    end
  end
end