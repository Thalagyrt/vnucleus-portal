module Licenses
  class License < ActiveRecord::Base
    belongs_to :account, class_name: ::Accounts::Account, inverse_of: :licenses
    belongs_to :product, inverse_of: :licenses

    validates :count, numericality: { greater_than_or_equal_to: 0 }

    validates :account, presence: true
    validates :product, presence: true

    scope :find_due, -> { where('next_due <= ?', Time.zone.today) }
    scope :find_current, -> { where('count > 0') }

    before_save :update_product_code
    before_save :update_description

    after_save :update_account_caches

    def to_s
      "#{product_code} (#{note})"
    end

    def self.monthly_rate
      where.not(free: true).joins(:product).sum('amount * count')
    end

    def bill_to(ledger, event_logger)
      with_lock do
        if count > 0
          if total_amount > 0
            ledger.add_debit(total_amount, transaction_message)
          end

          event_logger.with_entity(self).log(:license_billed)

          product.record_usage(account, count)

          # We reset the max_count to count so that it's set to the minimum usage for the next period.
          # We only want to bill on increases beyond the max count, so if a license starts at 5 count, up to 10, down to 7
          # then back up to 10, that user should only be billed for 10 total licenses during that billing period
          update_attributes! next_due: new_next_due, max_count: count
        else
          # At the point of billing, if the count is zero, let's just delete the license.
          destroy
        end
      end
    end

    def total_amount
      amount * count
    end

    def amount
      if free?
        0
      else
        product.amount
      end
    end

    def transaction_message(override_count = nil)
      message = "#{override_count || count}x #{product_code}: #{description}"
      message = "#{message} (#{note})" if note.present?
      message
    end

    private
    def new_next_due
      next_due + 1.month
    end

    def update_product_code
      if product_id_changed?
        self.product_code = product.product_code
      end
    end

    def update_description
      if product_id_changed?
        self.description = product.description
      end
    end

    private
    def update_account_caches
      account.update_monthly_rate_cache!
    end
  end
end