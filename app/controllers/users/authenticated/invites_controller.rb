module Users
  module Authenticated
    class InvitesController < ::Users::Authenticated::ApplicationController
      power :user_invites, as: :invites_scope

      before_filter :load_invite

      def show
        invite_claimer.on(:claim_success) do |account|
          flash[:notice] = 'Your invitation has been accepted.'
          redirect_to [:users, account]
        end

        invite_claimer.claim
      end

      private
      # Overridden to redirect to new registrations in the event of not being signed in
      def authenticate_user!
        unless current_user.present?
          session[:return_to] = request.fullpath
          session[:allow_registration] = true
          redirect_to [:new, :users, :registration]
        end
      end

      def load_invite
        @invite = invites_scope.find_by_token(URI.unescape(params[:token]))
      end

      def invite_claimer
        @invite_claimer ||= ::Users::InviteClaimer.new(
            user: current_user,
            invite: @invite,
            event_logger: account_event_logger
        )
      end

      def account_event_logger
        @account_event_logger ||= ::Accounts::EventLogger.new(account: @invite.account, ip_address: request.remote_ip, user: current_user)
      end
    end
  end
end