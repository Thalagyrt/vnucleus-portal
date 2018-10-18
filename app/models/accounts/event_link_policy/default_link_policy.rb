module Accounts
  module EventLinkPolicy
    class DefaultLinkPolicy
      def linkable?
        false
      end

      def route
        nil
      end
    end
  end
end