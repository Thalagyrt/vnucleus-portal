module Accounts
  class Transaction < ActiveRecord::Base
    include PgSearch
    TRANSACTION_TYPES = ['credit', 'debit', 'payment', 'refund', 'referral']

    belongs_to :account, inverse_of: :transactions

    validates :category, inclusion: { in: TRANSACTION_TYPES }

    scope :find_payments, -> { where(category: 'payment') }
    scope :find_referrals, -> { where(category: 'referral') }

    after_save :update_account_caches

    pg_search_scope :search,
                    against: { reference: 'A', description: 'C' },
                    associated_against: {
                        account: { long_id: 'C', name: 'B' }
                    },
                    using: {
                        tsearch: {
                            prefix: true,
                            dictionary: 'english'
                        }
                    }

    def self.payments_by_month
      Hash[find_payments.group("DATE_TRUNC('month', created_at)").sum('-amount').sort]
    end

    class << self
      def total
        sum(:amount)
      end

      def fees
        sum(:fee)
      end

      def find_in_year(year)
        where('created_at >= ? AND created_at < ?', "#{year}-01-01", "#{year+1}-01-01")
      end
    end

    def to_s
      "#{category.humanize} #{reference}"
    end

    private
    def update_account_caches
      account.update_balance_cache!
    end
  end
end