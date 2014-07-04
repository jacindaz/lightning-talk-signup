require 'rubygems'
require 'sinatra'
require 'sinatra/flash'
require 'pg'
require 'omniauth-github'
require 'dotenv'
Dotenv.load

Dir['app/models/*.rb'].each { |file| require_relative file }

configure do
  set :views, 'app/views'
  enable :sessions

  use OmniAuth::Builder do
    provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
    # scope: 'read:org'     eric didn't use this, not sure why?
  end
end

def production_database_config
  db_url_parts = ENV['DATABASE_URL'].split(/\/|:|@/)

  {
    user: db_url_parts[3],
    password: db_url_parts[4],
    host: db_url_parts[5],
    dbname: db_url_parts[7]
  }
end

configure :development do
  set :database_config, { dbname: 'lightning-talks_development' }
end

configure :production do
  set :database_config, production_database_config
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

def db_connection
  begin
    config = Sinatra::Application.settings.database_config
    connection = PG.connect(config)
    yield(connection)
  ensure
    connection.close
  end
end

configure :development, :testing do
  require 'pry'
end

#-----------------------------------ROUTES-----------------------------------------

get '/' do
  @all_talks = return_current_talks(24, 6, 2014)
  if signed_in?
    @current_user = User.return_current_user(current_user)
  end
  erb :index
end

get '/past_talks' do
  @past_talks = return_past_talks(24,6,2014)
  erb :past_talks
end

get '/what' do
  erb :what
end

get '/about' do
  erb :about
end

post '/add_talk' do
  @first_name = params["firstname"]
  @last_name = params["lastname"]
  @talk_title = params["usertalktopic"]
  @description = params["talk_description"]

  is_empty = is_empty?(@first_name, @last_name, @talk_title, @description)
  is_dupe = is_dupe?(@first_name, @last_name, @talk_title, @description)

  if !is_empty && !is_dupe
    save_to_db(@first_name, @last_name, @talk_title, @description)
    redirect '/thanks'
  elsif is_empty
    flash[:empty] = "You must fill out all fields to submit."
    redirect '/'
  elsif is_dupe
    flash[:dupe] = "This talk or user is a duplicate, please try again."
    redirect '/'
  else
    flash[:not_saved] = "I'm sorry, your talk could not be saved."
    redirect '/'
  end
end

get '/thanks' do
  erb :thanks
end

#-----------------------------------OMNIAUTH ROUTES-----------------------------------------
def authorize!
  unless signed_in?
    flash[:notice] = "You need to sign in first."
    redirect '/'
  end
end

helpers do
  def current_user
    @current_user ||= session['uid']
  end

  def signed_in?
    !current_user.nil?
  end
end

get '/talk' do
  authorize!
  erb :talk
end

get '/auth/:provider/callback' do
  # This is returns a hash with all of the information sent back by the
  # service (Github or Facebook)
  auth = env['omniauth.auth']

  # Build a hash that represents the user from the info given back from either
  # Facebook or Github
  user_attributes = {
    uid: auth['uid'],
    username: auth['info']['name'],
    provider: auth['provider'],
    email: auth['info']['email'],
    avatar_url: auth['info']['image'],
    location: auth['extra']['raw_info']['location'],
    company: auth['extra']['raw_info']['company'],
    nickname: auth['info']['nickname']
  }

  #user = User.create(user_attributes)
  User.create(user_attributes)

  # Save the id of the user that's logged in inside the session
  session["uid"] = user_attributes[:uid]
  session["avatar_url"] = user_attributes[:avatar_url]
  flash[:notice] = "You have signed in as #{user_attributes[:name]}"

  redirect '/'
end

get '/sign_out' do
  # Sign the user out by removing the id from the session
  session["uid"] = nil
  flash[:notice] = "You have signed out"

  redirect '/'
end

