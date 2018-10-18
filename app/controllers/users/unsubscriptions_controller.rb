module Users
  class UnsubscriptionsController < Users::ApplicationController
    layout 'dialog'

    def new
      @unsubscribe_form = UnsubscribeForm.new(email: params[:email].to_s)
    end

    def create
      @unsubscribe_form = UnsubscribeForm.new(unsubscribe_form_params)

      if @unsubscribe_form.valid?
        User.find_by_email(@unsubscribe_form.email).update_attributes(@unsubscribe_form.user_params)

        flash[:notice] = 'Thank you. Your preferences have been updated.'
        redirect_to [:root]
      else
        render :new
      end
    end

    private
    def unsubscribe_form_params
      params.require(:unsubscribe_form).permit(:email, :receive_security_bulletins, :receive_product_announcements)
    end
  end
end