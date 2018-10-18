module Admin
  class VisitsDatatable
    include SimpleDatatable

    sort_columns %w[ahoy_visits.id null null null null null ahoy_visits.created_at]

    def render(visit)
      {
          id: visit.link_id(:admin),
          user: visit.render_user,
          ip: visit.ip,
          landing_page: truncate_popover(visit.landing_page),
          referrer: truncate_popover(visit.referrer),
          utm_data: visit.render_utm_data,
          created_at: visit.render_created_at
      }
    end
  end
end