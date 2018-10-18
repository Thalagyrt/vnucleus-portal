module Users
  module Authenticated
    module Sessions
      class EnhancedSecurityTokensController < Users::Authenticated::Sessions::ApplicationController
        before_filter :ensure_unauthorized
        before_filter :prepare_address

        def new
          @enhanced_security_token_form = ::Users::Sessions::EnhancedSecurityTokenForm.new
        end

        def create
          enhanced_security_token_authorizer = ::Users::Sessions::EnhancedSecurityTokenAuthorizer.new(user: current_user, request: request, token: enhanced_security_token)

          enhanced_security_token_authorizer.on(:authorize_success) do
            redirect_logged_in_user
          end

          enhanced_security_token_authorizer.on(:authorize_failure) do |enhanced_security_token_form|
            @enhanced_security_token_form = enhanced_security_token_form
            render :new
          end

          enhanced_security_token_authorizer.authorize(enhanced_security_token_form_params)
        end

        def destroy
          session[:enhanced_security_token_email_sent] = false
          redirect_to [:new, :users, :sessions, :enhanced_security_tokens]
        end

        private
        def prepare_address
          Users::EnhancedSecurityTokenPreparer.new(user: current_user, request: request, token: enhanced_security_token).prepare(send_email: !session[:enhanced_security_token_email_sent])

          session[:enhanced_security_token_email_sent] = true
        end


        def ensure_unauthorized
          redirect_logged_in_user if current_user.verify_enhanced_security_token!(enhanced_security_token)
        end

        def enhanced_security_token_form_params
          params.require(:enhanced_security_token_form).permit(:authorization_code)
        end
      end
    end
  end
end