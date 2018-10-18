module Users
  module Authenticated
    module Accounts
      class InvitesController < Accounts::ApplicationController
        power :account_invites, context: :load_account, as: :invites_scope

        decorates_assigned :invite, :invites

        def index
          @invites = invites_scope.active
        end

        def new
          @invite = invites_scope.new
        end

        def create
          current_power.account_invites!(account)

          invite_creator.on(:create_success) do |invite|
            flash[:notice] = "Your invitation has been sent."
            redirect_to [:users, @account, :invites]
          end
          invite_creator.on(:create_failure) do |invite|
            @invite = invite
            render :new
          end

          invite_creator.create(invite_params)
        end

        def destroy
          @invite = invites_scope.find(params[:id])

          @invite.disable!
          account_event_logger.with_entity(@invite).with_category(:security).log(:invite_disabled)

          flash[:notice] = "Your invitation has been removed."
          redirect_to [:users, @account, :invites]
        end

        private
        def invite_creator
          @invite_creator ||= ::Accounts::InviteCreator.new(account: @account, event_logger: account_event_logger)
        end

        def invite_params
          params.require(:invite).permit(:email, roles: [])
        end
      end
    end
  end
end