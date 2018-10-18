module Users
  module NotificationLinkPolicy
    module Admin
      module Accounts
        class AccountLinkPolicy
          def initialize(target)
            @target = target
          end

          def linkable?
            true
          end

          def route
            [:admin, target]
          end

          private
          attr_reader :target
        end
      end
    end
  end
end