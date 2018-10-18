module Accounts
  module EventLinkPolicy
    module Solus
      class ServerLinkPolicy
        def initialize(entity)
          @entity = entity
        end

        def linkable?
          true
        end

        def route
          [:solus, @entity]
        end
      end
    end
  end
end