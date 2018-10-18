module Concerns
  module Users
    module Sessions
      module ApplicationControllerConcern
        extend ActiveSupport::Concern

        included do
          layout 'dialog'

          skip_before_filter :verify_otp!
          skip_before_filter :verify_enhanced_security_token!
        end
      end
    end
  end
end