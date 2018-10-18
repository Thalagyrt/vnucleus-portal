module Users
  module Passwords
    class TokenCreator
      include Wisper::Publisher

      def initialize(opts = {})
        @mailer_service_class = opts.fetch(:mailer_service_class) { ::Users::MailerService }
      end

      def create(params)
        token_form = TokenForm.new(params)

        if token_form.valid?
          @user = token_form.user

          mailer_service.reset_token

          publish :create_success
        else
          publish :create_failure, token_form
        end
      end

      private
      attr_reader :user, :mailer_service_class

      def mailer_service
        @mailer_service ||= mailer_service_class.new(user: user)
      end
    end
  end
end