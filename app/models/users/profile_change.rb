module Users
  class ProfileChange < ActiveRecord::Base
    belongs_to :user, inverse_of: :profile_changes

    scope :sorted, -> { order(:created_at) }
  end
end