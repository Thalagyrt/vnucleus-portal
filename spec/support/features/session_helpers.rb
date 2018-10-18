module Features
  module SessionHelpers
    def sign_in(user)
      page.set_rack_session(user_id: user.id, otp_verified: true)
    end

    def sign_out
      page.set_rack_session(user_id: nil, otp_verified: false)
    end

    def form_based_sign_in(user, opts = {})
      email = opts.fetch(:email) { user.email }
      password = opts.fetch(:password) { user.password }

      visit new_users_sessions_session_path

      fill_in 'session_form_email', with: email
      fill_in 'session_form_password', with: password

      click_button 'session_form_submit'

      if user.enhanced_security?
        authorization_code = opts.fetch(:authorization_code) { user.enhanced_security_tokens.first.authorization_code }

        fill_in 'enhanced_security_token_form_authorization_code', with: authorization_code

        click_button 'enhanced_security_token_form_submit'
      end

      if user.otp_enabled?
        otp = opts.fetch(:otp) { ROTP::TOTP.new(user.otp_secret).now }

        fill_in 'one_time_password_form_otp', with: otp

        click_button 'one_time_password_form_submit'
      end
    end

    def form_based_sign_out
      visit root_path

      click_link 'Sign Out'
    end
  end
end