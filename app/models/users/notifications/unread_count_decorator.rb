module Users
  module Notifications
    class UnreadCountDecorator < ApplicationDecorator
      delegate_all

      decorates_association :new_notifications
    end
  end
end