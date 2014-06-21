require 'pg'
require 'pry'

def db_connection
  begin
    connection = PG.connect(dbname: 'lightning-talks_development')
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

def save_to_db(first, last, topic)
  insert = "INSERT INTO talks (first_name, last_name, talk_title, created_at)
              VALUES ($1, $2, $3, now())"
  @insert_db = db_connection do |conn|
              conn.exec_params(insert, [first, last, topic])
            end
end

def is_empty?(first, last, topic)
  return first.empty? || last.empty? || topic.empty?
end
#puts is_empty?('', '', '')               # returns true
puts is_empty?('', 'Zhong', '')           # returns true

def remove_double_quote(string)
  if string
  end
end

#true if no duplicates, false if is a dupe
def is_dupe?(first, last, topic)
  all_talks = return_all_talks
  first_exist = false
  last_exist = false
  topic_exist = false
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
    if (topic_exist || (first_exist && last_exist)) == true
      return true
    end
  end
  false
end

#puts is_dupe?("Jacinda", "Blah", "lala")       # return false
#puts is_dupe?('Jacinda', 'Zhong', 'lala')       # return true

