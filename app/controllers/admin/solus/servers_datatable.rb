module Admin
  module Solus
    class ServersDatatable
      include SimpleDatatable

      sort_columns %w[solus_servers.long_id solus_servers.hostname null null solus_plans.ram null null solus_servers.amount null solus_servers.patch_at null]

      def render(server)
        {
            id: server.link_long_id(:admin),
            hostname: server.link_hostname(:admin),
            ip_address: server.ip_address,
            account: server.account.link_to_s(:admin),
            plan: server.render_plan_name,
            template: server.template_name,
            location: "#{server.cluster_name} / #{server.node_name || "N/A"} / #{server.xen_id || "N/A"}",
            patch_at: server.render_patch_at,
            amount: server.render_amount,
            managed: server.render_managed,
            state: server.render_state,
        }
      end
    end
  end
end