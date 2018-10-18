module Validations
  class PhonesController < ApplicationController
    def create
      render json: Phonelib.parse(params[:phone]).valid?
    end
  end
end