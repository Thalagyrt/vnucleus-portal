module Service
  class Notice < ActiveRecord::Base
    validates :message, presence: true
  end
end