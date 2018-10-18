module Admin
  module Communications
    module Announcements
      class SendsController < Admin::Communications::Announcements::ApplicationController
        def create
          announcement_sender.on(:send_success) do
            flash[:notice] = 'The announcement was sent.'
            redirect_to [:admin, :communications, @announcement]
          end

          announcement_sender.on(:send_failure) do
            flash[:alert] = 'The announcement could not be sent.'
            redirect_to [:admin, :communications, @announcement]
          end

          announcement_sender.send
        end

        private
        def announcement_sender
          @announcement_sender ||= ::Communications::AnnouncementSender.new(announcement: @announcement, sender: current_user)
        end
      end
    end
  end
end