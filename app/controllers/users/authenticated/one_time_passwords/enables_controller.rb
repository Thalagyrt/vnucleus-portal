module Users
  module Authenticated
    module OneTimePasswords
      class EnablesController < Users::Authenticated::ApplicationController
        before_filter :guard_adding_tokens!

        def new
          @enable_form = ::Users::OneTimePasswords::EnableForm.new(user: current_user)
        end

        def create
          @enable_form = ::Users::OneTimePasswords::EnableForm.new(enable_form_params.merge(user: current_user))

          if @enable_form.valid?
            current_user.update_attribute :otp_secret, @enable_form.otp_secret
            self.otp_verified = true
            flash[:notice] = 'Authenticator has been enabled.'
            redirect_to [:users, :one_time_passwords, :statuses]
          else
            render :new
          end
        end

        private
        def enable_form_params
          params.require(:enable_form).permit(:otp, :otp_secret)
        end

        def guard_adding_tokens!
          render_404 if current_user.otp_secret.present?
        end
      end
    end
  end
end