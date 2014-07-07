require 'dotenv'
Dotenv.load

require 'sinatra'
require 'sinatra/flash'
require 'omniauth-github'
require 'pg'

Dir['app/models/*.rb'].each { |file| require_relative file }

#-----------------------------------METHODS-----------------------------------------
def production_database_config
  db_url_parts = ENV['DATABASE_URL'].split(/\/|:|@/)

  {
    user: db_url_parts[3],
    password: db_url_parts[4],
    host: db_url_parts[5],
    dbname: db_url_parts[7]
  }
end

def authorize!
  unless signed_in?
    flash[:notice] = "You need to sign in first."
    redirect '/'
  end
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html

  def signed_in?
    #binding.pry
    session.has_key?("uid")
  end
end

#-----------------------------------CONFIGURE-----------------------------------------
configure do
  set :views, 'app/views'
  enable :sessions

  use OmniAuth::Builder do
    provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'],
    scope: 'read:org'
  end
end

configure :development do
  set :database_config, { dbname: 'lightning-talks_development' }
  require 'pry'
  require 'sinatra/reloader'
end

configure :production do
  set :database_config, production_database_config
end

#-----------------------------------ROUTES-----------------------------------------

get '/' do
  @all_talks = Talk.return_current_talks(24, 6, 2014)
  if signed_in?
    puts "I am in the / route, and think I am signed in"
    puts "This is the session: #{session}"
    @current_user = User.return_current_user(session["uid"])
  end

  erb :index
end

get '/past_talks' do
  @past_talks = Talk.return_past_talks(24,6,2014)
  erb :past_talks
end

get '/what' do
  erb :what
end

get '/about' do
  erb :about
end

post '/add_talk' do
  @current_user = User.return_current_user(session["uid"])
  talk_info = {
      uid: @current_user.uid,
      talk_title: params["usertalktopic"],
      description: params["talk_description"],
      username: @current_user.username,
      avatar_url: @current_user.avatar_url
    }

  new_talk = Talk.new(talk_info)
  binding.pry

  if Talk.any_talks?
    is_empty = new_talk.is_empty?
    is_dupe = new_talk.is_dupe?
  else
    no_talks = true
  end

  if !is_empty && !is_dupe && !no_talks
    new_talk.save_to_db
    redirect '/thanks'
  elsif is_empty
    flash[:empty] = "You must fill out all fields to submit."
    redirect '/'
  elsif is_dupe
    flash[:dupe] = "This is a duplicate, please try again."
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

  # if user exists, find, if not, create
  if !(User.return_current_user(user_attributes[:uid])).nil?
    @current_user = User.return_current_user(user_attributes[:uid])
  else
    @current_user = User.insert_db(user_attributes)
  end

  # Save the id of the user that's logged in inside the session
  session["uid"] = user_attributes[:uid]
  flash[:notice] = "Hello, #{@current_user.username}!"
  redirect '/'
end

get '/sign_out' do
  # Sign the user out by removing the id from the session
  session["uid"] = nil
  session["avatar_url"] = nil
  flash[:notice] = "See ya later!"

  redirect '/'
end

