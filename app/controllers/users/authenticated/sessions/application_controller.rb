module Users
  module Authenticated
    module Sessions
      class ApplicationController < Users::Authenticated::ApplicationController
        include ::Concerns::Users::Sessions::ApplicationControllerConcern
      end
    end
  end
end