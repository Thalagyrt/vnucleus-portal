module Users
  module Authenticated
    module Accounts
      class TicketsDatatable
        include SimpleDatatable

        sort_columns %w[tickets_tickets.long_id tickets_tickets.subject tickets_tickets.updated_at null tickets_tickets.priority tickets_tickets.status]

        def render(ticket)
          {
              id: ticket.link_long_id(:users),
              subject: ticket.link_subject(:users),
              updated_at: ticket.render_updated_at,
              updated_by: ticket.render_updated_by,
              priority: ticket.render_priority,
              status: ticket.render_status,
          }
        end
      end
    end
  end
end