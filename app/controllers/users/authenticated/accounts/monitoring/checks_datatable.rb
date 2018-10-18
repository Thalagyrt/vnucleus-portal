module Users
  module Authenticated
    module Accounts
      module Monitoring
        class ChecksDatatable
          include SimpleDatatable

          sort_columns %w[monitoring_checks.long_id null monitoring_checks.status_code monitoring_checks.server_hostname monitoring_checks.test_to_s monitoring_checks.last_run_at]

          def render(check)
            {
                long_id: check.link_long_id(:users),
                active: check.render_active,
                status_code: check.render_status_code,
                server: check.server.link_to_s(:users),
                test_to_s: check.test_to_s,
                last_run_at: check.render_last_run_at,
                row_class: check.row_class,
            }
          end
        end
      end
    end
  end
end