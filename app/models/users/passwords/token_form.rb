module Users
  module Passwords
    class TokenForm
      include ActiveModel::Model

      attr_reader :email

      validates :email, presence: true
      validate :ensure_user_present

      def email=(value)
        @email = value.downcase
      end

      def user
        ::Users::User.find_by_email(email)
      end

      private
      def ensure_user_present
        unless user.present?
          errors[:email] << 'not found'
        end
      end
    end
  end
end