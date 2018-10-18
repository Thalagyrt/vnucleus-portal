module Users
  class EventLogger
    def initialize(opts = {})
      @user = opts.fetch(:user)
      @category = opts.fetch(:category, nil)
      @ip_address = opts.fetch(:ip_address, nil)
    end

    def with_category(category)
      clone.tap do |logger|
        logger.instance_variable_set(:@category, category)
      end
    end

    def with_ip_address(ip_address)
      clone.tap do |logger|
        logger.instance_variable_set(:@ip_address, ip_address)
      end
    end

    def log(message)
      user.events.create(message: message, category: category, ip_address: ip_address)
    end

    private
    attr_accessor :user, :category, :ip_address
  end
end