module Concerns
  module Tickets
    module TicketStatusModelConcern
      extend ActiveSupport::Concern

      CLIENT_STATUSES = ['open', 'client_reply', 'closed']
      STAFF_STATUSES =  ['open', 'staff_reply', 'closed']

      included do
        extend Enumerize

        enumerize :status, in: { open: 1, client_reply: 2, staff_reply: 3, closed: 6 }, scope: true, default: :open
      end
    end
  end
end