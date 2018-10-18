module Users
  module OneTimePasswords
    class Status
      include ActiveModel::Model
      include Draper::Decoratable

      attr_reader :user

      def initialize(opts = {})
        @user = opts.fetch(:user)
      end

      def otp_state
        user.otp_enabled? ? 'enabled' : 'disabled'
      end
    end
  end
end