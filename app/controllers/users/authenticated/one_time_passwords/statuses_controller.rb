module Users
  module Authenticated
    module OneTimePasswords
      class StatusesController < Users::Authenticated::ApplicationController
        decorates_assigned :status

        def show
          @status = ::Users::OneTimePasswords::Status.new(user: current_user)
        end
      end
    end
  end
end