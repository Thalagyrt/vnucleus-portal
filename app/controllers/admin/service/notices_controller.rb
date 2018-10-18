module Admin
  module Service
    class NoticesController < Admin::ApplicationController
      power :admin_service_notices, as: :notices_scope

      decorates_assigned :notices, :notice

      def index
        @notices = notices_scope
        @notice = notices_scope.new
      end

      def create
        @notice = notices_scope.new(notice_params)

        if @notice.save
          flash[:notice] = 'The notice has been added.'
          redirect_to [:admin, :service, :notices]
        else
          render :new
        end
      end

      def destroy
        notices_scope.find(params[:id]).destroy

        flash[:notice] = 'The notice has been removed.'
        redirect_to [:admin, :service, :notices]
      end

      private
      def notice_params
        params.require(:notice).permit(:message)
      end
    end
  end
end