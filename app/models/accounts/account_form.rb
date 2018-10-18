module Accounts
  class AccountForm
    include ActiveModel::Model

    attr_accessor :account_entity_name, :account_nickname, :affiliate_id
    attr_accessor :credit_card_token, :credit_card_address_line1, :credit_card_address_line2, :credit_card_address_city,
                  :credit_card_address_state, :credit_card_address_zip, :credit_card_address_country, :credit_card_name,
                  :credit_card_expiration_month, :credit_card_expiration_year

    validates :account_entity_name, presence: true
    validates :credit_card_name, presence: true
    validates :credit_card_token, presence: true
    validates :credit_card_address_line1, presence: true
    validates :credit_card_address_city, presence: true
    validates :credit_card_address_state, presence: true
    validates :credit_card_address_zip, presence: true
    validates :credit_card_address_country, presence: true

    def credit_card_params
      {
          name: credit_card_name,
          token: credit_card_token,
          address_line1: credit_card_address_line1,
          address_line2: credit_card_address_line2,
          address_city: credit_card_address_city,
          address_state: credit_card_address_state,
          address_zip: credit_card_address_zip,
          address_country: credit_card_address_country,
          expiration_month: credit_card_expiration_month,
          expiration_year: credit_card_expiration_year,
      }
    end

    def account_params
      {
          entity_name: account_entity_name,
          nickname: account_nickname,
          referrer: affiliate,
      }
    end

    private
    def affiliate
      ::Accounts::Account.where(long_id: affiliate_id).first
    end
  end
end