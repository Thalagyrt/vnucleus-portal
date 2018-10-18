module Users
  module Sessions
    class OneTimePasswordForm
      include ActiveModel::Model

      attr_accessor :otp

      validates :otp, presence: true
    end
  end
end