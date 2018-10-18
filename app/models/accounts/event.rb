module Accounts
  class Event < ActiveRecord::Base
    include Concerns::LongIdModelConcern

    belongs_to :account, inverse_of: :events
    belongs_to :user, class_name: ::Users::User
    belongs_to :entity, polymorphic: true
  end
end