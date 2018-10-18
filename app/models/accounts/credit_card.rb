module Accounts
  class CreditCard
    include ActiveModel::Model
    include Draper::Decoratable

    validates :name, presence: true
    validates :token, presence: true
    validates :address_line1, presence: true
    validates :address_city, presence: true
    validates :address_state, presence: true
    validates :address_zip, presence: true
    validates :address_country, presence: true

    attr_accessor :id, :token, :name, :expiration_month, :expiration_year, :type, :last_4,
                  :address_line1, :address_line2, :address_city, :address_state, :address_zip, :address_country

    class << self
      def from_card(card)
        new(
            id: card.id,
            name: card.name,
            last_4: card.last4,
            expiration_month: card.exp_month,
            expiration_year: card.exp_year,
            type: card.type,
            address_line1: card.address_line1,
            address_line2: card.address_line2,
            address_city: card.address_city,
            address_state: card.address_state,
            address_country: card.address_country,
            address_zip: card.address_zip,
        )
      end
    end

    def expiration_date
      Date.parse("#{expiration_year}-#{expiration_month}-01")
    end


    def masked_number
      "****#{last_4}"
    end

    def to_s
      "#{type} #{masked_number}"
    end
  end
end