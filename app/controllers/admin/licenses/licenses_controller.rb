module Admin
  module Licenses
    class LicensesController < Admin::ApplicationController
      power :admin_licenses, as: :licenses_scope

      decorates_assigned :licenses

      def index
        @licenses = licenses_scope.includes(:account, :product)
      end
    end
  end
end