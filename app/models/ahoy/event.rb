module Ahoy
  class Event < ActiveRecord::Base
    belongs_to :visit, inverse_of: :events
    belongs_to :user, class_name: ::Users::User

    serialize :properties, JSON
  end
end