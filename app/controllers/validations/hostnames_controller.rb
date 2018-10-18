module Validations
  class HostnamesController < ApplicationController
    def create
      render json: Solus::Hostname.valid_hostname?(params[:hostname])
    end
  end
end