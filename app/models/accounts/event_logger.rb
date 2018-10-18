module Accounts
  class EventLogger
    def initialize(opts = {})
      @account = opts.fetch(:account)
      @category = opts.fetch(:category, nil)
      @user = opts.fetch(:user, nil)
      @entity = opts.fetch(:entity, nil)
      @ip_address = opts.fetch(:ip_address, nil)
    end

    def with_category(category)
      clone.tap do |logger|
        logger.instance_variable_set(:@category, category)
      end
    end

    def with_user(user)
      clone.tap do |logger|
        logger.instance_variable_set(:@user, user)
      end
    end

    def with_entity(entity)
      clone.tap do |logger|
        logger.instance_variable_set(:@entity, entity)
      end
    end

    def with_ip_address(ip_address)
      clone.tap do |logger|
        logger.instance_variable_set(:@ip_address, ip_address)
      end
    end

    def log(message)
      account.events.create(message: message, user: user, entity: entity, category: category, ip_address: ip_address)
    end

    private
    attr_reader :account, :user, :entity, :category, :ip_address
  end
end