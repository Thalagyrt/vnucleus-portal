module Admin
  module Dedicated
    class ServersDatatable
      include SimpleDatatable

      sort_columns %w[dedicated_servers.long_id dedicated_servers.hostname null null dedicated_servers.patch_at dedicated_servers.amount dedicated_servers.managed dedicated_servers.state]

      def render(server)
        {
            id: server.link_long_id(:admin),
            hostname: server.link_hostname(:admin),
            ip_address: server.ip_address,
            account: server.account.link_to_s(:admin),
            patch_at: server.render_patch_at,
            amount: server.render_amount,
            managed: server.render_managed,
            state: server.render_state,
        }
      end
    end
  end
end