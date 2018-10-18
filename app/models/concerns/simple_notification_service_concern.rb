module Concerns
  module SimpleNotificationServiceConcern
    extend ActiveSupport::Concern

    module ClassMethods
      def define_notifier(notifier, &block)
        define_method(notifier) do |opts = {}|
          process_notifier(notifier, opts, &block)
        end
      end

      def define_notifiers(*notifiers, &block)
        notifiers.each do |notifier|
          define_notifier(notifier, &block)
        end
      end
    end

    private
    def process_notifier(message, opts = {}, &block)
      users.each do |user|
        if block_given? && instance_exec(power_for(user), &block) || !block_given?
          if opts[:actor] != user
            user.notifications.create(opts.merge(message: message, link_policy: link_policy))
          end
        end
      end
    end

    def power_for(user)
      Power.new(user)
    end
  end
end