module Tickets
  class Update < ActiveRecord::Base
    include Concerns::Tickets::TicketStatusModelConcern
    include Concerns::Tickets::TicketPriorityModelConcern

    authorize_values_for :status

    belongs_to :ticket, inverse_of: :updates
    belongs_to :user, class_name: ::Users::User

    validates :user, presence: true
    validates :body, presence: true, if: :body_required?

    before_create :set_sequence_number

    scope :sorted, -> { order('sequence ASC') }

    def self.with_minimum_sequence(sequence)
      where('sequence >= ?', sequence)
    end

    private
    def body_required?
      [:open, :closed].exclude?(status.try(:to_sym)) || ticket.status == status
    end

    def set_sequence_number
      loop do
        self.sequence = (ticket.updates.maximum(:sequence) || 0) + 1
        break unless self.class.exists?(:sequence => self.sequence, ticket_id: self.ticket.id)
      end
    end
  end
end