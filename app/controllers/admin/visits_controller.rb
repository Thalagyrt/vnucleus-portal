module Admin
  class VisitsController < Admin::ApplicationController
    power :admin_visits, as: :visits_scope

    decorates_assigned :visits, :visit

    def index
      respond_to do |format|
        format.html
        format.json { render json: VisitsDatatable.new(visits_scope.includes(:user), view_context) }
      end
    end

    def show
      @visit = visits_scope.find(params[:id])
    end
  end
end