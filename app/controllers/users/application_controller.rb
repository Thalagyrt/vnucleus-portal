module Users
  class ApplicationController < ::ApplicationController
    private
    def user_event_logger
      @user_event_logger ||= EventLogger.new(user: current_user, ip_address: request.remote_ip)
    end
  end
end