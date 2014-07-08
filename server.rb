require 'dotenv'
Dotenv.load
require 'sinatra'
require 'sinatra/flash'
require 'omniauth-github'
require 'pg'
Dir['app/models/*.rb'].each { |file| require_relative file }

helpers do
  include Rack::Utils
  alias_method :h, :escape_html

  def signed_in?
    session.has_key?("uid")
  end
end

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
  set :database_config, Database.production_database_config
end

#-----------------------------------ROUTES-----------------------------------------

get '/' do
  @all_talks = Talk.return_current_talks(24, 6, 2014)
  if signed_in?
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

  if Talk.any_talks?
    is_empty = new_talk.is_empty?
    is_dupe = Talk.is_dupe?(new_talk.topic)
  end

  if !is_empty && !is_dupe
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
get '/auth/:provider/callback' do
  auth = env['omniauth.auth']
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
    session["username"] = user_attributes[:username]
    flash[:notice] = "Welcome back, #{session["username"]}!"
  else
    @current_user = User.insert_db(user_attributes)
    session["username"] = user_attributes[:username]
    flash[:notice] = "Welcome, #{session["username"]}!"
  end

  session["uid"] = user_attributes[:uid]
  redirect '/'
end

get '/sign_out' do
  session["uid"] = nil
  session["username"] = nil
  flash[:notice] = "See ya later!"
  redirect '/'
end

