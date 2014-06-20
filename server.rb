require 'sinatra'
require 'rubygems'
require 'pry'
require 'pg'



#METHODS--------------------------------------------------------------------------------
def db_connection
  begin
    connection = PG.connect(dbname: 'lightning-talks_development')

    yield(connection)

  ensure
    connection.close
  end
end


#ROUTES and VIEWS--------------------------------------------------------------------------------


get '/' do

  all_talks = "SELECT * FROM talks"

  actor_query = "SELECT actors.id,actors.name,
                    movies.title AS movie, movies.id AS movie_id,
                    cast_members.character AS role
                 FROM actors
                    JOIN cast_members ON actors.id = cast_members.actor_id
                    JOIN movies ON cast_members.movie_id = movies.id
                  WHERE actors.id = $1"

  @talks = db_connection do |conn|
              conn.exec_params(all_talks)
            end

  erb :index
end



