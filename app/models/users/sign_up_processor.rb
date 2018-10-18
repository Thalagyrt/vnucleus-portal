module Users
  class SignUpProcessor
    include Wisper::Publisher

    def initialize(opts = {})
      @request = opts.fetch(:request)
      @enhanced_security_token = opts.fetch(:enhanced_security_token)
      @user_authenticator = opts.fetch(:user_authenticator) { ::Users::Sessions::UserAuthenticator.new(request: request) }
    end

    def process(params)
      @sign_up_form = SignUpForm.new(params)

      if sign_up_form.valid?
        user_creator.on(:create_success) do |user|
          account = ::Accounts::Account.create!(entity_name: user.full_name, referrer: referrer)
          account.memberships.create!(user: user, roles: [:full_control])

          if new_account_credit_amount > 0
            Rails.logger.info { "Adding new credit account of #{MoneyFormatter.format_amount(new_account_credit_amount)} to account #{account}"}

            batch_transaction_service = ::Accounts::BatchTransactionService.new(account: account)
            batch_transaction_service.batch do |batch|
              batch.add_credit(new_account_credit_amount, 'Thanks for trying our service!')
            end
          end

          publish(:process_success, user, account)
        end
        user_creator.on(:create_failure) do
          publish(:process_failure, sign_up_form)
        end

        user_creator.create(sign_up_form.user_form_params)
      else
        user_authenticator.on(:authentication_success) do |user|
          publish(:authentication_success, user)
        end
        user_authenticator.on(:authentication_failure) do |session_form|
          publish(:authentication_failure, session_form)
        end

        user_authenticator.authenticate(params.slice(:email, :password))
      end
    end

    private
    attr_reader :request, :sign_up_form, :session_form, :user_authenticator, :enhanced_security_token

    def user_creator
      @user_creator ||= ::Users::UserCreator.new(request: request, enhanced_security_token: enhanced_security_token)
    end

    def referrer
      @referrer ||= begin
        ::Accounts::Account.find_by_param(sign_up_form.affiliate_id)
      rescue ActiveRecord::RecordNotFound
        nil
      end
    end

    def new_account_credit_amount
      Rails.application.config.new_account_credit_amount
    end
  end
end