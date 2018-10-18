module Users
  module Authenticated
    class NotificationsController < ::Users::Authenticated::ApplicationController
      power :user_notifications, as: :notifications_scope

      skip_before_filter :update_current_user

      decorates_assigned :notifications, :notification

      def index
        @notifications = notifications_scope.includes(:actor, :target).sorted.find_recent

        notifications_scope.mark_all_read if params[:mark_all_read].present?
      end

      def show
        @notification = notifications_scope.find(params[:id])

        @notification.mark_read

        respond_to do |format|
          format.html do
            policy_finder = ::Users::NotificationLinkPolicy::Finder.new(notification: @notification)

            if policy_finder.linkable?
              redirect_to policy_finder.route
            else
              redirect_to :back
            end
          end

          format.js
        end
      end
    end
  end
end