module Users
  module NotificationLinkPolicy
    module Admin
      module Tickets
        class TicketLinkPolicy
          def initialize(target)
            @target = target
          end

          def linkable?
            true
          end

          def route
            [:admin, account, target]
          end

          private
          attr_reader :target
          delegate :account, to: :target
        end
      end
    end
  end
end