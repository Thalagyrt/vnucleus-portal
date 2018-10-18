module Users
  module Passwords
    class ResetForm
      include ActiveModel::Model

      attr_accessor :password

      validates :password, presence: true, confirmation: true, length: { minimum: 8 }
    end
  end
end