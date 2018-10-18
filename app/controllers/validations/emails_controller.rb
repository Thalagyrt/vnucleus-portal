module Validations
  class EmailsController < ApplicationController
    def create
      render json: !Users::User.exists?(email: params[:email])
    end
  end
end