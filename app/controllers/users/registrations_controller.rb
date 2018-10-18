module Users
  class RegistrationsController < Users::ApplicationController
    before_filter :ensure_registration_allowed!
    before_filter :ensure_return_to!

    layout 'dialog'

    def new
      @user_form = UserForm.new
    end

    def create
      user_creator.on(:create_success) do |user|
        self.current_user = user
        session.delete(:allow_registration)
        redirect_to session.delete(:return_to)
      end
      user_creator.on(:create_failure) do |user_form|
        @user_form = user_form
        render :new
      end

      user_creator.create(user_params)
    end

    private
    def user_creator
      @user_creator ||= UserCreator.new(request: request, enhanced_security_token: enhanced_security_token)
    end

    def user_params
      params.require(:user_form).permit(:email, :password)
    end

    def ensure_registration_allowed!
      render_404 unless session[:allow_registration]
    end

    def ensure_return_to!
      render_404 unless session[:return_to]
    end
  end
end