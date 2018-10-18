module Users
  class Event < ActiveRecord::Base
    belongs_to :user, inverse_of: :events
  end
end