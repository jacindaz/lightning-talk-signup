require 'pg'

def db_connection
  begin
    connection = PG.connect(settings.database_config)
    yield(connection)
  ensure
    connection.close
  end
end

def return_all_talks
  all_talks = "SELECT * FROM talks"
  talks = db_connection do |conn|
              conn.exec_params(all_talks)
            end
end

def query_db(query, params)

  db_connection do |conn|
    conn.exec_params(query, [params])
  end
end

def save_to_db(first, last, topic, description)
  insert = "INSERT INTO talks (first_name, last_name, talk_title, description, created_at)
              VALUES ($1, $2, $3, $4, now())"
  @insert_db = db_connection do |conn|
              conn.exec_params(insert, [first, last, topic, description])
            end
end

def is_empty?(first, last, topic, description)
  return first.empty? || last.empty? || topic.empty? || description.empty?
end

def is_dupe?(first, last, topic, description)
  all_talks = return_all_talks
  first_exist = false
  last_exist = false
  topic_exist = false
  description_exist = false
  return_all_talks.each do |talk|
    if talk["first_name"] == first
      first_exist = true
    end
    if talk["last_name"] == last
      last_exist = true
    end
    if talk["talk_title"] == topic
      topic_exist = true
    end
    if talk["talk_description"] == description
      description_exist = true
    end
    if (topic_exist || (first_exist && last_exist) || description_exist) == true
      return true
    end
  end
  false
end
