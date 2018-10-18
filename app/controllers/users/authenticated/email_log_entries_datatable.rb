module Users
  module Authenticated
    class EmailLogEntriesDatatable
      include SimpleDatatable

      sort_columns %w[null null null users_email_log_entries.created_at]

      def render(email_log_entry)
        {
            id: email_log_entry.link_to_param(:users),
            to: email_log_entry.to,
            subject: email_log_entry.subject,
            created_at: email_log_entry.render_created_at
        }
      end
    end
  end
end