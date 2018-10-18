module Licenses
  class LicenseUpdater
    include Wisper::Publisher

    def initialize(opts = {})
      @license = opts.fetch(:license)
      @batch_transaction_service = opts.fetch(:batch_transaction_service) { ::Accounts::BatchTransactionService.new(account: account) }
    end

    def update(params)
      if license.update_attributes(params)
        if license.count > license.max_count
          difference = license.count - license.max_count

          if license.amount > 0
            batch_transaction_service.batch do |batch|
              batch.add_debit(license.amount * difference, license.transaction_message(difference))
            end
          end

          product.record_usage(account, difference)
          license.update_attributes max_count: license.count
        end

        publish :update_success
      else
        publish :update_failure, license
      end
    end

    private
    attr_reader :license, :batch_transaction_service
    delegate :product, :account, to: :license
  end
end