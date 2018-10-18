module Users
  class SignUpsController < Users::ApplicationController
    before_filter :ensure_anonymous

    layout 'dialog'

    def new
      @sign_up_form = SignUpForm.new(affiliate_id: cookies[:affiliate_id])
    end

    def create
      sign_up_processor.on(:process_success) do |user, account|
        self.current_user = user
        redirect_to [:users, account]
      end
      sign_up_processor.on(:process_failure) do |sign_up_form|
        @sign_up_form = sign_up_form
        render :new
      end

      sign_up_processor.on(:authentication_success) do |user|
        self.current_user = user
        flash[:notice] = "Welcome back, #{current_user.first_name}!"
        redirect_logged_in_user
      end
      sign_up_processor.on(:authentication_failure) do |session_form|
        @session_form = session_form

        # This one may seem a bit weird, but I wanted to display the session form in this case.
        render :sign_in
      end

      sign_up_processor.process(user_form_params)
    end

    private
    def sign_up_processor
      @sign_up_processor ||= SignUpProcessor.new(request: request, enhanced_security_token: enhanced_security_token)
    end

    def user_form_params
      params.require(:sign_up_form).permit(:email, :password, :affiliate_id)
    end

    def ensure_anonymous
      if current_user.present?
        if current_user.current_accounts.count == 0
          redirect_to [:new, :users, :account]
        elsif current_user.current_accounts.count == 1
          redirect_to [:users, current_user.current_accounts.first]
        else
          redirect_to [:users, :accounts]
        end
      end
    end
  end
end