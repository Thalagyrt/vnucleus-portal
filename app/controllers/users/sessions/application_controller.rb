module Users
  module Sessions
    class ApplicationController < Users::ApplicationController
      include ::Concerns::Users::Sessions::ApplicationControllerConcern
    end
  end
end