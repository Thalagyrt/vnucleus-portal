module Users
  module Authenticated
    module Emails
      class TokensController < ::Users::Authenticated::ApplicationController
        def create
          mailer_service.email_confirmation

          flash[:notice] = "An email with confirmation instructions has been sent to #{current_user.email}."

          redirect_to request.referrer
        end

        private
        def mailer_service
          ::Users::MailerService.new(user: current_user)
        end
      end
    end
  end
end