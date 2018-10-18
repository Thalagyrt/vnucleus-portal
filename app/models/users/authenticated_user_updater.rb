module Users
  class AuthenticatedUserUpdater
    include Wisper::Publisher

    def initialize(opts = {})
      @user = opts.fetch(:user)
      @mailer_service = opts.fetch(:mailer_service) { ::Users::MailerService.new(user: user) }
    end

    def update(params)
      clean_password(params)

      if update_user(params)
        unless user.email_confirmed?
          mailer_service.email_confirmation
        end

        publish(:update_success)
      else
        publish(:update_failure, user)
      end
    end

    private
    attr_reader :user, :mailer_service

    def update_user(params)
      current_password = extract_password(params)

      if user.authenticate(current_password)
        if user.update_attributes(params)
          user.accounts.each do |account|
            if account.entity_name == user.email
              account.update_attributes entity_name: user.full_name
            end
          end

          true
        end
      else
        authentication_failure(params, current_password)
      end
    end

    def authentication_failure(params, current_password)
      user.assign_attributes(params)
      user.valid?

      user.errors.add(:current_password, current_password.blank? ? :blank : :invalid)

      false
    end

    def extract_password(params)
       params.delete(:current_password)
    end

    def clean_password(params)
      if params[:password].blank?
        params.delete(:password)
        params.delete(:password_confirmation)
      end
    end
  end
end