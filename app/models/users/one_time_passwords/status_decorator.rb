module Users
  module OneTimePasswords
    class StatusDecorator < ApplicationDecorator
      delegate_all
    end
  end
end