module Admin
  module Communications
    class AnnouncementsController < Admin::ApplicationController
      power :admin_communications_announcements, as: :announcements_scope, map: { [:edit, :update, :destroy] => :updatable_admin_communications_announcements }

      decorates_assigned :announcement, :announcements, :users_receiving_announcements

      def index
        @announcements = announcements_scope.includes(:sent_by)
      end

      def show
        @announcement = announcements_scope.find(params[:id])
      end

      def new
        @announcement = announcements_scope.new
      end

      def create
        @announcement = announcements_scope.new(announcement_params)

        if @announcement.save
          flash[:notice] = 'Your announcement has been created.'
          redirect_to [:admin, :communications, @announcement]
        else
          render :new
        end
      end

      def edit
        @announcement = announcements_scope.find(params[:id])
      end

      def update
        @announcement = announcements_scope.find(params[:id])

        if @announcement.update_attributes(announcement_params)
          flash[:notice] = 'The announcement has been updated.'
          redirect_to [:admin, :communications, @announcement]
        else
          render :edit
        end
      end

      def destroy
        @announcement = announcements_scope.find(params[:id])

        if @announcement.destroy
          flash[:notice] = 'The announcement has been deleted.'
          redirect_to [:admin, :communications, :announcements]
        end
      end

      private
      def announcement_params
        params.require(:announcement).permit(:subject, :body, :announcement_type)
      end
    end
  end
end