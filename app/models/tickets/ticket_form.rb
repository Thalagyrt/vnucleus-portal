module Tickets
  class TicketForm
    include ActiveModel::Model
    include Concerns::Tickets::TicketPriorityModelConcern

    attr_accessor :subject, :body, :secure_body

    validates :subject, presence: true
    validates :body, presence: true
  end
end