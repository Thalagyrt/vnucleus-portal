module Users
  module Sessions
    class EnhancedSecurityTokenAuthorizer
      include Wisper::Publisher

      def initialize(opts = {})
        @user = opts.fetch(:user)
        @token = opts.fetch(:token)
        @request = opts.fetch(:request)
      end

      def authorize(params)
        enhanced_security_token_form = EnhancedSecurityTokenForm.new(params)

        if enhanced_security_token_form.valid?
          enhanced_security_token = user.enhanced_security_tokens.find_active.where(token: token, authorization_code: enhanced_security_token_form.authorization_code).first

          if enhanced_security_token.present?
            enhanced_security_token.authorized = true
            enhanced_security_token.save!

            return publish(:authorize_success)
          end

          enhanced_security_token_form.errors[:authorization_code] << :incorrect
        end

        publish(:authorize_failure, enhanced_security_token_form)
      end

      private
      attr_reader :user, :request, :token
    end
  end
end