module Accounts
  class BackupUserDecorator < ApplicationDecorator
    include ::Concerns::TimestampDecoratorConcern

    delegate_all

    def login_url
      "https://#{hostname}/j_spring_security_check"
    end
  end
end