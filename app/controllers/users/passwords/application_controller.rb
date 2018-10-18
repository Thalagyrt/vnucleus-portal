module Users
  module Passwords
    class ApplicationController < Users::ApplicationController
      layout 'dialog'

      before_filter :ensure_not_logged_in!

      private
      def ensure_not_logged_in!
        render_404 if current_user.present?
      end
    end
  end
end