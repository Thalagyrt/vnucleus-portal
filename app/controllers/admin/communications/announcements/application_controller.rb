module Admin
  module Communications
    module Announcements
      class ApplicationController < Admin::ApplicationController
        power :admin_communications_announcements, as: :announcements_scope

        before_filter :load_announcement

        decorates_assigned :announcement

        private
        def load_announcement
          @announcement ||= announcements_scope.find(params[:announcement_id])
        end
      end
    end
  end
end