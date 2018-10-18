module Admin
  module Monitoring
    module Checks
      class EnablesController < Admin::Monitoring::Checks::ApplicationController
        before_filter :ensure_can_enable

        def create
          @check.update_attributes enabled: true

          flash[:notice] = 'The check has been enabled.'
          redirect_to [:admin, :monitoring, @check]
        end

        private
        def ensure_can_enable
          return if @check.can_enable?

          flash[:alert] = 'The check cannot be enabled.'
          redirect_to [:admin, :monitoring, @check]
        end
      end
    end
  end
end