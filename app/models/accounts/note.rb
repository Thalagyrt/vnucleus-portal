module Accounts
  class Note < ActiveRecord::Base
    belongs_to :account, inverse_of: :notes
    belongs_to :user, class_name: ::Users::User

    validates :body, presence: true

    scope :sorted, -> { order('created_at DESC') }
  end
end