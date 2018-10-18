module Controllers
  module SessionHelpers
    def sign_in(user)
      session[:user_id] = user.id

      if user.otp_enabled?
        session[:otp_verified] = true
      end
    end
  end
end