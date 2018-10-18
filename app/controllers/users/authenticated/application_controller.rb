module Users
  module Authenticated
    class ApplicationController < ::Users::ApplicationController
      before_filter :authenticate_user!

      private
      def authenticate_user!
        unless current_user.present?
          session[:return_to] = request.fullpath
          redirect_to [:new, :users, :sessions, :session]
        end
      end
    end
  end
end