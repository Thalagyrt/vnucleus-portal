module Users
  module Notifications
    class UnreadCount
      include Draper::Decoratable

      def initialize(opts = {})
        @notifications_scope = opts.fetch(:notifications_scope)
        @sequence = opts[:sequence] || max_sequence
      end

      def max_sequence
        notifications_scope.maximum(:id)
      end

      def new_notifications
        notifications_scope.where('id > ?', sequence)
      end

      delegate :unread_count, to: :notifications_scope

      def css_class
        if unread_count >= 20
          "text-danger"
        elsif unread_count >= 1
          "text-warning"
        else
          ""
        end
      end

      private
      attr_reader :notifications_scope, :sequence
    end
  end
end