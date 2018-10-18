module Accounts
  class Membership < ActiveRecord::Base
    include Concerns::Accounts::RoleModelConcern
    include Concerns::LongIdModelConcern

    validates :account, presence: true
    validates :user, presence: true

    belongs_to :account, inverse_of: :memberships
    belongs_to :user, class_name: ::Users::User, inverse_of: :account_memberships

    before_save :update_roles

    private
    def update_roles
      if roles.include? :full_control
        self.roles = [:full_control]
      end
    end
  end
end