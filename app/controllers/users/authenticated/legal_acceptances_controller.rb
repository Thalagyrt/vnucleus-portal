module Users
  module Authenticated
    class LegalAcceptancesController < ::Users::Authenticated::ApplicationController
      def create
        current_user.update_attributes legal_accepted: true

        redirect_to request.referrer
      end

      private
      def ensure_logged_in
        render_404 unless current_user.present?
      end
    end
  end
end