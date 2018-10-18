module Solus
  class EnableSmtpsController < ApplicationController
    def show
      @server = Solus::Server.find_current.find_by_xen_id!(params[:id])

      if @server.enable_smtp?
        head :ok
      else
        head :forbidden
      end
    end
  end
end