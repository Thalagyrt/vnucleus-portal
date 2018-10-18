module Licenses
  class UsageReport
    include ActiveModel::Model
    include Draper::Decoratable

    def initialize(opts = {})
      @usages_scope = opts.fetch(:usages_scope)
      @start_date = opts.fetch(:start_date).to_date
      @usages_scope = opts.fetch(:usages_scope)
      @products_scope = opts.fetch(:products_scope)
    end

    attr_reader :start_date

    def persisted?
      true
    end

    def id
      start_date.strftime("%Y-%m")
    end

    def to_s
      start_date.strftime("%B %Y")
    end

    def end_date
      start_date + 1.month
    end

    def products
      products_scope.joins(:usages).group('licenses_products.id').select('licenses_products.*, sum(licenses_usages.count) AS usage_count').merge(usages_scope.for_month(start_date))
    end

    private
    attr_reader :products_scope, :usages_scope
  end
end