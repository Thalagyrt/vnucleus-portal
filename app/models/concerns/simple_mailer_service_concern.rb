module Concerns
  module SimpleMailerServiceConcern
    extend ActiveSupport::Concern

    module ClassMethods
      def define_mailer(mailer, &block)
        define_method(mailer) do |opts = {}|
          process_mailer(mailer, opts, &block)
        end
      end

      def define_mailers(*mailers, &block)
        mailers.each do |mailer|
          define_mailer(mailer, &block)
        end
      end
    end

    private
    def process_mailer(action, opts = {}, &block)
      users.each do |user|
        if block_given? && instance_exec(power_for(user), &block) || !block_given?
          mailer.delay(priority: Rails.application.config.mailer_queue_priority).send(action, merge_opts(user, opts))
        end
      end
    end

    def power_for(user)
      Power.new(user)
    end
  end
end