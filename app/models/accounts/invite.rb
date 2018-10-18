module Accounts
  class Invite < ActiveRecord::Base
    include Concerns::Accounts::RoleModelConcern

    belongs_to :account, inverse_of: :invites

    validates :email, presence: true, email: true
    validates :account, presence: true

    scope :active, -> { where(state: :active) }

    state_machine :state, initial: :active do
      event :disable do
        transition :active => :disabled
      end

      event :claim do
        transition :active => :claimed
      end
    end

    class << self
      def token_verifier
        Rails.application.message_verifier('Accounts::Invite')
      end

      def find_by_token(token)
        find(token_verifier.verify(token))
      end
    end

    def to_s
      "#{id} (#{email})"
    end

    def token
      self.class.token_verifier.generate(id)
    end
  end
end