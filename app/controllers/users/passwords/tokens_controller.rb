module Users
  module Passwords
    class TokensController < Users::Passwords::ApplicationController
      def new
        @token_form = TokenForm.new
      end

      def create
        token_creator.on(:create_success) do
          flash[:notice] = "Reset instructions have been sent."
          redirect_to root_path
        end

        token_creator.on(:create_failure) do |token_form|
          @token_form = token_form
          render :new
        end

        token_creator.create(token_params)
      end

      private
      def token_creator
        @token_creator ||= TokenCreator.new
      end

      def token_params
        params.require(:token_form).permit(:email)
      end
    end
  end
end