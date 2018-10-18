module Users
  module Authenticated
    module OneTimePasswords
      class DisablesController < Users::Authenticated::ApplicationController
        before_filter :guard_removing_tokens!

        def new
          @disable_form = ::Users::OneTimePasswords::DisableForm.new
        end

        def create
          @disable_form = ::Users::OneTimePasswords::DisableForm.new(disable_form_params)

          if @disable_form.valid? && current_user.authenticate(@disable_form.password)
            current_user.update_attribute :otp_secret, nil
            self.otp_verified = false
            flash[:notice] = 'Authenticator has been disabled.'
            redirect_to [:users, :one_time_passwords, :statuses]
          else
            @disable_form.errors[:password] << :invalid
            render :new
          end
        end

        private
        def disable_form_params
          params.require(:disable_form).permit(:password)
        end

        def guard_removing_tokens!
          render_404 unless current_user.otp_enabled?
        end
      end
    end
  end
end