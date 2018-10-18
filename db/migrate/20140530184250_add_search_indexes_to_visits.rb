class AddSearchIndexesToVisits < ActiveRecord::Migration
  def up
    execute "CREATE INDEX visits_utm_medium ON visits USING gin(to_tsvector('english', utm_medium))"
    execute "CREATE INDEX visits_utm_campaign ON visits USING gin(to_tsvector('english', utm_campaign))"
    execute "CREATE INDEX visits_utm_source ON visits USING gin(to_tsvector('english', utm_source))"
    execute "CREATE INDEX visits_ip ON visits USING gin(to_tsvector('english', ip))"
    execute "CREATE INDEX visits_landing_page ON visits USING gin(to_tsvector('english', landing_page))"
    execute "CREATE INDEX visits_referrer ON visits USING gin(to_tsvector('english', referrer))"
  end

  def down
    execute "DROP INDEX visits_utm_medium"
    execute "DROP INDEX visits_utm_campaign"
    execute "DROP INDEX visits_utm_source"
    execute "DROP INDEX visits_ip"
    execute "DROP INDEX visits_landing_page"
    execute "DROP INDEX visits_referrer"
  end
end
