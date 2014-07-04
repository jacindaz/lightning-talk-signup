class User

  attr_reader :id, :uid, :provider,
    :email, :avatar_url, :username,
    :location, :company, :nickname

  def initialize(attributes)
    @id = attributes["id"]
    @uid = attributes["uid"]
    @provider = attributes["provider"]
    @email = attributes["email"]
    @avatar_url = attributes["avatar_url"]
    @username = attributes["username"]
    @location = attributes["location"]
    @company = attributes["company"]
    @nickname = attributes["nickname"]
  end

  def self.create(attributes)
    insert_db = "INSERT INTO users (uid, email, avatar_url, username, location, company, nickname, provider, created_at)
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, now())"
    new_user = Database.connection do |conn|
              conn.exec_params(insert_db, [attributes[:uid],
                                  attributes[:email],
                                  attributes[:avatar_url],
                                  attributes[:username],
                                  attributes[:location],
                                  attributes[:company],
                                  attributes[:nickname],
                                  attributes[:provider]])
            end
  end

  def self.all
    # This should query the database for all of the users
    all_talks_query = "SELECT * FROM talks"
    all_talks = connection.exec(all_talks_query)
  end

  def self.return_current_user(user_id)
    query_user = "SELECT * FROM users WHERE uid = $1"
    current_user = Database.connection do |conn|
              conn.exec_params(query_user, [user_id])
            end
  end

  # does user already exist?
  def user_exists?(user_id, all_users)
    all_users.each do |user|
      return true if user["uid"] == user_id
    end
    false
  end

end



