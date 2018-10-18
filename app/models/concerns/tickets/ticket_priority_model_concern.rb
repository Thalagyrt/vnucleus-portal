module Concerns
  module Tickets
    module TicketPriorityModelConcern
      extend ActiveSupport::Concern

      included do
        extend Enumerize

        enumerize :priority, in: { normal: 1, critical: 3 }, default: :normal
      end
    end
  end
end