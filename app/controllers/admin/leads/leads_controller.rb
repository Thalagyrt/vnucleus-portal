module Admin
  module Leads
    class LeadsController < Admin::ApplicationController
      decorates_assigned :leads, :lead

      power :admin_leads, as: :leads_scope

      def index
        @leads = leads_scope.all
      end

      def show
        @lead = leads_scope.find(params[:id])
      end
    end
  end
end