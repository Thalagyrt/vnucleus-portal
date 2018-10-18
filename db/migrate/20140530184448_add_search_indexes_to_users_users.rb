class AddSearchIndexesToUsersUsers < ActiveRecord::Migration
  def up
    execute("CREATE INDEX users_users_email ON users_users USING gin(to_tsvector('english', email))")
    execute("CREATE INDEX users_users_first_name ON users_users USING gin(to_tsvector('english', first_name))")
    execute("CREATE INDEX users_users_last_name ON users_users USING gin(to_tsvector('english', last_name))")
  end

  def down
    execute("DROP INDEX users_users_email")
    execute("DROP INDEX users_users_first_name")
    execute("DROP INDEX users_users_last_name")
  end
end
