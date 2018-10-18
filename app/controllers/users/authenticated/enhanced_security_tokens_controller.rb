module Users
  module Authenticated
    class EnhancedSecurityTokensController < Users::Authenticated::ApplicationController
      power :user_enhanced_security_tokens, as: :enhanced_security_tokens_scope

      decorates_assigned :enhanced_security_tokens

      def index
        @enhanced_security_tokens = enhanced_security_tokens_scope.find_active
      end

      def destroy
        @enhanced_security_token = enhanced_security_tokens_scope.find_by_param(params[:id])

        @enhanced_security_token.destroy

        redirect_to [:users, :enhanced_security_tokens]
      end
    end
  end
end