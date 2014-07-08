require_relative 'database'

class Talk

  attr_reader :uid, :topic, :description, :username, :avatar_url, :created_at

  def initialize(attributes)
    @uid = attributes[:uid]
    @topic = attributes[:talk_title]
    @description = attributes[:description]
    @username = attributes[:username]
    @avatar_url = attributes[:avatar_url]
    @created_at = DateTime.now
  end

  #-----------------------------------QUERY THE DB-----------------------------------------
  def self.return_all_talks
    all_talks_query = "SELECT users.username, users.avatar_url, users.uid,
                    talks.talk_title, talks.created_at, talks.description, talks.uid
                  FROM users
                    JOIN talks ON talks.uid = users.uid"
    talks = Database.connection do |conn|
      conn.exec(all_talks_query)
    end
    if !talks.nil?
      all_talks = []
      talks.each do |talk|
        all_talks << Talk.new(talk)
      end
      return all_talks
    else
      return nil
    end
  end

  def self.return_current_talks(day, month, year)
    talk_date = "#{year}-#{month}-#{day} 23:59:59.999999"
    current_talks = "SELECT users.username, users.avatar_url, users.uid,
                    talks.talk_title, talks.created_at, talks.description, talks.uid
                  FROM users
                    JOIN talks ON talks.uid = users.uid
                  WHERE talks.created_at > $1"
    talks = Database.connection do |conn|
      conn.exec_params(current_talks, [talk_date])
    end
  end

  def self.return_past_talks(day, month, year)
    talk_date = "#{year}-#{month}-#{day} 23:59:59.999999"
    current_talks = "SELECT users.username, users.avatar_url, users.uid,
                    talks.talk_title, talks.created_at, talks.description, talks.uid
                  FROM users
                    JOIN talks ON talks.uid = users.uid
                  WHERE talks.created_at > $1"
    talks = Database.connection do |conn|
      conn.exec_params(current_talks, [talk_date])
    end
  end

  def self.any_talks?
    any_talks_query = "SELECT * FROM talks"
    talks = Database.connection do |conn|
      conn.exec(any_talks_query)
    end
    !talks.nil? ? true : false
  end

  def save_to_db
    insert = "INSERT INTO talks (uid, talk_title, description, created_at)
              VALUES ($1, $2, $3, now())"
    @insert_db = Database.connection do |conn|
      conn.exec_params(insert, [uid, topic, description])
    end
  end

  #-----------------------------------DB VALIDATIONS-----------------------------------------
  def is_empty?
    uid_validation = uid.empty? || (uid == "")
    description_validation = description.empty? || (description == "")
    topic_validation = topic.empty? || (topic == "")
    return uid_validation || topic_validation || description_validation
  end

  def self.is_dupe?(topic)
    query_talks = "SELECT * FROM talks WHERE talk_title = $1"
    talks = Database.connection do |conn|
      conn.exec_params(query_talks, [topic]).first
    end
    !talks.nil? ? true : false
  end

end
