module Users
  module Authenticated
    module Notifications
      class UnreadCountsController < ::Users::Authenticated::ApplicationController
        power :user_notifications, as: :notifications_scope

        decorates_assigned :unread_count

        skip_before_filter :update_current_user

        def show
          @unread_count = ::Users::Notifications::UnreadCount.new(notifications_scope: notifications_scope.find_recent, sequence: params[:sequence])

          respond_to do |format|
            format.js
            format.html { redirect_to [:root] }
          end
        end
      end
    end
  end
end