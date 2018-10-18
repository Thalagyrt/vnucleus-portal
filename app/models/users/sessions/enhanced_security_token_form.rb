module Users
  module Sessions
    class EnhancedSecurityTokenForm
      include ActiveModel::Model

      attr_accessor :authorization_code

      validates :authorization_code, presence: true
    end
  end
end