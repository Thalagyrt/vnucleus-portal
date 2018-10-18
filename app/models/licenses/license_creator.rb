module Licenses
  class LicenseCreator
    include Wisper::Publisher

    def initialize(opts = {})
      @account = opts.fetch(:account)
      @license_factory = opts.fetch(:license_factory)
      @batch_transaction_service = opts.fetch(:batch_transaction_service) { ::Accounts::BatchTransactionService.new(account: account) }
    end

    def create(params)
      @license = license_factory.new(params.merge(next_due: Time.zone.today.next_month.at_beginning_of_month))

      if license.save
        if license.amount > 0
          batch_transaction_service.batch do |batch|
            batch.add_debit(license.amount * license.count, license.transaction_message(license.count))
          end
        end

        product.record_usage(account, license.count)
        license.update_attributes max_count: license.count

        publish :create_success, license
      else
        publish :create_failure, license
      end
    end

    private
    attr_reader :license, :license_factory, :account, :batch_transaction_service
    delegate :product, to: :license
  end
end