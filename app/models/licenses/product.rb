module Licenses
  class Product < ActiveRecord::Base
    extend Enumerize

    has_many :licenses, inverse_of: :product
    has_many :usages, inverse_of: :product

    validates :product_code, presence: true
    validates :amount, numericality: { greater_than_or_equal_to: 0 }

    after_save :update_licenses

    def record_usage(account, count)
      usages.create!(account: account, count: count)
    end

    def self.usage_report(reference_date)
      joins(:usages).group('licenses_products.id').select('licenses_products.*, sum(licenses_usages.count) AS usage_count').merge(Licenses::Usage.for_month(reference_date))
    end

    def to_s
      "#{product_code} (#{description})"
    end

    private
    def update_licenses
      if description_changed? || product_code_changed?
        licenses.update_all description: description, product_code: product_code
      end
    end
  end
end