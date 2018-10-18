module Users
  module NotificationLinkPolicy
    module Users
      module Tickets
        class TicketLinkPolicy
          def initialize(target)
            @target = target
          end

          def linkable?
            true
          end

          def route
            [:users, account, target]
          end

          private
          attr_reader :target
          delegate :account, to: :target
        end
      end
    end
  end
end