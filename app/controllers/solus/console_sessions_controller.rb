module Solus
  class ConsoleSessionsController < ApplicationController
    def show
      @console_session = ConsoleSession.find_by!(ip_address: params[:id])
    end
  end
end