module Tickets
  class Ticket < ActiveRecord::Base
    include PgSearch

    include Concerns::LongIdModelConcern
    include Concerns::Tickets::TicketStatusModelConcern
    include Concerns::Tickets::TicketPriorityModelConcern

    belongs_to :account, class_name: Accounts::Account, inverse_of: :tickets

    validates :account, presence: true
    validates :subject, presence: true

    has_many :updates, dependent: :delete_all

    accepts_nested_attributes_for :updates

    scope :find_awaiting_client_action, -> { with_status :staff_reply }
    scope :find_awaiting_staff_action, -> { with_status :open, :client_reply }
    scope :find_open, -> { without_status :closed }

    pg_search_scope :search,
                    against: { long_id: 'C', subject: 'A' },
                    associated_against: {
                        updates: { body: 'B' }
                    },
                    using: {
                        tsearch: {
                            prefix: true,
                            dictionary: 'english'
                        }
                    }

    def to_s
      "#{long_id} (#{subject})"
    end

    def updated_by
      updates.last && updates.last.user
    end

    def open?
      ['open', 'client_reply', 'staff_reply'].include? status
    end

    def body?
      body.present?
    end

    def subject=(value)
      super(value.strip)
    end
  end
end