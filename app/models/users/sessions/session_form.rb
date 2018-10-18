module Users
  module Sessions
    class SessionForm
      include ActiveModel::Model

      attr_reader :email
      attr_accessor :password

      validates :email, presence: true
      validates :password, presence: true

      def email=(value)
        @email = value.downcase
      end
    end
  end
end