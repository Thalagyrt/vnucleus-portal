module Validations
  class StocksController < ApplicationController
    def show
      @cluster = Solus::Cluster.find(params[:cluster_id])
      @plan = Solus::Plan.find(params[:plan_id])
      @stock = @cluster.stock(@plan)
    end

    def create
      show
      render :show
    end
  end
end