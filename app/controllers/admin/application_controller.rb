module Admin
  class ApplicationController < Users::Authenticated::ApplicationController
    before_filter :ensure_staff!
    before_filter :enforce_otp!
    before_filter :assign_tickets_awaiting_staff_action

    private
    def ensure_staff!
      unless current_user.is_staff?
        logger.info { "Non-staff user attempted admin access" }

        render_404
      end
    end

    def enforce_otp!
      unless current_user.otp_enabled?
        logger.info { "User attempted admin access without OTP" }

        flash[:alert] = "Staff users are required to use two factor authentication."
        redirect_to [:new, :users, :one_time_passwords, :enables]
      end
    end

    def assign_tickets_awaiting_staff_action
      @tickets_awaiting_staff_action = Tickets::Ticket.find_awaiting_staff_action
    end
  end
end