module Users
  module NotificationLinkPolicy
    class Finder
      attr_reader :notification

      delegate :target, to: :notification

      delegate :route, :linkable?, to: :policy

      def initialize(opts = {})
        @notification = opts.fetch(:notification)
      end

      private
      def policy
        policy = "#{self.class.to_s.deconstantize}::#{notification.link_policy.camelize}::#{target.class}LinkPolicy"
        puts policy
        policy.constantize.new(target)
      rescue NameError
        DefaultLinkPolicy.new
      end
    end
  end
end