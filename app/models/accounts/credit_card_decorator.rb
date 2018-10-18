module Accounts
  class CreditCardDecorator < ApplicationDecorator
    delegate_all

    def render_expiration_date
      object.expiration_date.strftime("%m/%Y")
    end
  end
end