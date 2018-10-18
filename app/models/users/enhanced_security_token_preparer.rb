module Users
  class EnhancedSecurityTokenPreparer
    def initialize(opts = {})
      @user = opts.fetch(:user)
      @request = opts.fetch(:request)
      @token = opts.fetch(:token)
      @mailer_service = opts.fetch(:mailer_service) { MailerService.new(user: user) }
    end

    def prepare(opts = {})
      enhanced_security_tokens.clean_up

      enhanced_security_token = enhanced_security_tokens.find_or_initialize_by(token: token)
      opts[:send_email] = true if enhanced_security_token.new_record?

      enhanced_security_token.seen!(request: request)

      mailer_service.enhanced_security_token_authorization_code(enhanced_security_token: enhanced_security_token) if opts[:send_email]
    end
    
    private
    attr_reader :user, :request, :mailer_service, :token
    delegate :enhanced_security_tokens, to: :user
  end
end