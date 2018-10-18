module Users
  module NotificationLinkPolicy
    module Users
      module Solus
        class ServerLinkPolicy
          def initialize(target)
            @target = target
          end

          def linkable?
            true
          end

          def route
            [:users, account, :solus, target]
          end

          private
          attr_reader :target
          delegate :account, to: :target
        end
      end
    end
  end
end