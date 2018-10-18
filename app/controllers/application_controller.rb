class ApplicationController < ActionController::Base
  protect_from_forgery

  concerning :Affiliates do
    included do
      before_filter :store_affiliate_id_in_cookie
      before_filter :clean_affiliate
    end

    private
    def store_affiliate_id_in_cookie
      return unless params[:affiliate_id].present?

      cookies[:affiliate_id] = { value: params[:affiliate_id], expires: Time.zone.now + 1.month }
    end

    def clean_affiliate
      return unless cookies[:affiliate_id].present?

      affiliate = ::Accounts::Account.where(long_id: cookies[:affiliate_id]).first
      return unless affiliate.present?

      if affiliate.users.include?(current_user)
        cookies.delete(:affiliate_id)
      end
    end
  end

  concerning :Authorization do
    included do
      include Consul::Controller

      current_power do
        Power.new(current_user)
      end

      rescue_from Consul::Powerless do
        render_404
      end
    end
  end

  concerning :Browsers do
    included do
      before_filter :assign_browser_id!
      before_filter :log_browser_id
    end

    def browser_id
      cookies.signed[:browser_id]
    end

    def assign_browser_id!
      unless browser_id.present?
        cookies.permanent.signed[:browser_id] = { value: SecureRandom.uuid, httponly: true }
      end
    end

    def log_browser_id
      logger.info { "Browser ID: #{browser_id}" }
    end
  end

  concerning :Coupons do
    included do
      before_filter :store_coupon_in_cookie
    end

    private
    def store_coupon_in_cookie
      return unless params[:coupon_code].present?

      cookies[:coupon_code] = { value: params[:coupon_code], expires: Time.zone.now + 1.month }
    end
  end

  concerning :EnhancedSecurity do
    included do
      before_filter :assign_enhanced_security_token!
      before_filter :verify_enhanced_security_token!
    end

    private
    def enhanced_security_token
      cookies.signed[:enhanced_security_token]
    end

    def assign_enhanced_security_token!
      unless enhanced_security_token.present?
        cookies.permanent.signed[:enhanced_security_token] = { value: SecureRandom.uuid, httponly: true }
      end
    end

    def verify_enhanced_security_token!
      return unless current_user.try(:enhanced_security?)
      return if current_user.verify_enhanced_security_token!(enhanced_security_token, request: request)

      logger.info { "Forcing Enhanced Security validation on #{current_user}" }

      session[:return_to] = request.fullpath
      redirect_to [:new, :users, :sessions, :enhanced_security_tokens]
    end
  end

  concerning :Errors do
    included do
      rescue_from ActiveRecord::RecordNotFound do
        render_404
      end
    end

    private
    def render_404
      respond_to do |format|
        format.html { render file: 'public/404.html', status: :not_found, layout: false }
        format.json { render json: { status: :not_found }, status: :not_found }
      end
    end
  end

  concerning :Notices do
    included do
      before_filter :assign_service_notices
    end

    private
    def assign_service_notices
      @service_notices = Service::Notice.all
    end
  end

  concerning :Sessions do
    included do
      before_filter :update_current_user
      before_filter :log_current_user
      helper_method :current_user
    end

    def current_user
      @current_user ||= Users::User.where(id: session[:user_id], session_generation: session[:user_session_generation]).first
    end

    def current_user=(user)
      @current_user = user

      if user.present?
        session[:user_id] = @current_user.try(:id)
        session[:user_session_generation] = @current_user.try(:session_generation)
      else
        reset_session
      end

      if current_visit and !current_visit.user
        current_visit.user = current_user
        current_visit.save!
      end
    end

    private
    def update_current_user
      return unless current_user
      return if request.xhr? && request.get?

      current_user.update_attributes active_at: Time.zone.now
    end

    def log_current_user
      return unless current_user

      logger.info { "Current User: #{current_user}" }
    end

    def redirect_logged_in_user
      if session[:return_to].present?
        redirect_to session.delete(:return_to)
      elsif current_user.is_staff?
        redirect_to [:admin, :dashboard]
      elsif current_user.accounts.count == 1
        redirect_to [:users, current_user.accounts.first]
      else
        redirect_to [:users, :accounts]
      end
    end
  end

  concerning :TwoFactor do
    included do
      before_filter :verify_otp!
    end

    private
    def otp_verified
      session[:otp_verified]
    end

    def otp_verified=(val)
      session[:otp_verified] = val
    end

    def verify_otp!
      return if otp_verified
      return unless current_user.try(:otp_enabled?)

      logger.info { "Forcing OTP validation on #{current_user.email}" }

      session[:return_to] = request.fullpath
      redirect_to [:new, :users, :sessions, :one_time_password]
    end
  end
end
