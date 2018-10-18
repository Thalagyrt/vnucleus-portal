module Concerns
  module Accounts
    module RoleModelConcern
      extend ActiveSupport::Concern

      included do
        include RoleModel

        roles :full_control, :manage_billing, :manage_servers
      end
    end
  end
end