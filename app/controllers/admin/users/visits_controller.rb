module Admin
  module Users
    class VisitsController < Admin::Users::ApplicationController
      power :admin_user_visits, context: :load_user, as: :visits_scope

      decorates_assigned :visits, :visit

      def index
        render json: VisitsDatatable.new(visits_scope.includes(:user), view_context)
      end
    end
  end
end