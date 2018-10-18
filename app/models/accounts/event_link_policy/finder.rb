module Accounts
  module EventLinkPolicy
    class Finder
      attr_reader :event

      delegate :entity, to: :event

      delegate :route, :linkable?, to: :policy

      def initialize(opts = {})
        @event = opts.fetch(:event)
      end

      private
      def policy
        "#{self.class.to_s.deconstantize}::#{entity.class}LinkPolicy".constantize.new(entity)
      rescue NameError
        DefaultLinkPolicy.new
      end
    end
  end
end