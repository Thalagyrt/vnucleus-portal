module Admin
  module Monitoring
    module Checks
      class ApplicationController < Admin::ApplicationController
        power :admin_monitoring_checks, as: :checks_scope

        decorates_assigned :check

        before_filter :load_check

        private
        def load_check
          @check = checks_scope.find_by_param(params[:check_id])
        end
      end
    end
  end
end