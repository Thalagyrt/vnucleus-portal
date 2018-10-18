module Admin
  module Monitoring
    module Checks
      class DisablesController < Admin::Monitoring::Checks::ApplicationController
        def create
          @check.update_attributes enabled: false

          flash[:notice] = 'The check has been disabled.'
          redirect_to [:admin, :monitoring, @check]
        end
      end
    end
  end
end