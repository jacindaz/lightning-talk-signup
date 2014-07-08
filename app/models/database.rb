class Database
  def self.connection
    begin
      config = Sinatra::Application.settings.database_config
      connection = PG.connect(config)
      yield(connection)
    ensure
      connection.close
    end
  end

  def self.production_database_config
    db_url_parts = ENV['DATABASE_URL'].split(/\/|:|@/)

    {
      user: db_url_parts[3],
      password: db_url_parts[4],
      host: db_url_parts[5],
      dbname: db_url_parts[7]
    }
  end

end
