require_relative 'database'

class Talk

  attr_reader :uid, :topic, :description

  def initialize(uid, topic, description)
    @uid = uid
    @topic = topic
    @description = description
  end

  #-----------------------------------QUERY THE DB-----------------------------------------
  def self.return_all_talks
    all_talks = "SELECT * FROM talks"
    talks = Database.connection do |conn|
                conn.exec(all_talks)
              end
  end

  def self.return_current_talks(day, month, year)
    talk_date = "#{year}-#{month}-#{day} 23:59:59.999999"
    current_talks = "SELECT * FROM talks WHERE created_at > $1"
    talks = Database.connection do |conn|
                conn.exec_params(current_talks, [talk_date])
              end
  end

  def self.return_past_talks(day, month, year)
    talk_date = "#{year}-#{month}-#{day} 23:59:59.999999"
    current_talks = "SELECT * FROM talks WHERE created_at < $1"
    talks = Database.connection do |conn|
                conn.exec_params(current_talks, [talk_date])
              end
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

  def is_dupe?
    all_talks = Talk.return_all_talks
    uid_exist = false
    topic_exist = false
    description_exist = false
    all_talks.each do |talk|
      if talk["uid"] == uid
        uid_exist = true
      end
      if talk["topic"] == topic
        topic_exist = true
      end
      if talk["description"] == description
        description_exist = true
      end
      if ((topic_exist && uid_exist) || description_exist) == true
        return true
      end
    end
    false
  end

end
