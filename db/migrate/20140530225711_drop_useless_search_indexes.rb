class DropUselessSearchIndexes < ActiveRecord::Migration
  def up
    execute "DROP INDEX visits_utm_medium"
    execute "DROP INDEX visits_utm_campaign"
    execute "DROP INDEX visits_utm_source"
    execute "DROP INDEX visits_ip"
    execute "DROP INDEX visits_landing_page"
    execute "DROP INDEX visits_referrer"
    execute("DROP INDEX users_users_email")
    execute("DROP INDEX users_users_first_name")
    execute("DROP INDEX users_users_last_name")
  end

  def down
    execute "CREATE INDEX visits_utm_medium ON visits USING gin(to_tsvector('english', utm_medium))"
    execute "CREATE INDEX visits_utm_campaign ON visits USING gin(to_tsvector('english', utm_campaign))"
    execute "CREATE INDEX visits_utm_source ON visits USING gin(to_tsvector('english', utm_source))"
    execute "CREATE INDEX visits_ip ON visits USING gin(to_tsvector('english', ip))"
    execute "CREATE INDEX visits_landing_page ON visits USING gin(to_tsvector('english', landing_page))"
    execute "CREATE INDEX visits_referrer ON visits USING gin(to_tsvector('english', referrer))"
    execute("CREATE INDEX users_users_email ON users_users USING gin(to_tsvector('english', email))")
    execute("CREATE INDEX users_users_first_name ON users_users USING gin(to_tsvector('english', first_name))")
    execute("CREATE INDEX users_users_last_name ON users_users USING gin(to_tsvector('english', last_name))")
  end
end
