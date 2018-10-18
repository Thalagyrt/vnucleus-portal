module Users
  module OneTimePasswords
    class DisableForm
      include ActiveModel::Model

      attr_accessor :password

      validates :password, presence: true
    end
  end
end