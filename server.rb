require 'rubygems'
require 'sinatra'
require 'sinatra/flash'
require 'pg'

Dir['app/models/*.rb'].each { |file| require_relative file }

configure do
  set :views, 'app/views'
  enable :sessions

  use OmniAuth::Builder do
    provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'],
    scope: 'read:org'
  end
end

configure :development, :testing do
  set :session_secret, "random string"
end

#-----------------------------------ROUTES-----------------------------------------

get '/' do
  @all_talks = return_current_talks(24, 6, 2014)
  erb :index
end

get '/past_talks' do
  @past_talks = return_past_talks(24,6,2014)
  erb :past_talks
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

get '/auth/:provider/callback' do
  #returns a hash with info sent from the provider (such as fb/github)
  auth = env['omniauth.auth']
  #parse the hash and retain important user info
  user_info = {
    first_name: auth['info']['name'],
    uid: auth['uid'],
    email: auth['info']['email'],
    avatar_url: auth['info']['image']
  }
  find_or_create(user_info)

  #save user info into a session
  session["uid"] = user_info[:uid]
  session["avatar"] = user_info[:avatar_url]
  flash[:notice] = "You are signed in as #{user_info[:first_name]}"
  redirect '/'
end

get '/sign_out' do
  session["uid"] = nil
  session["avatar"] = nil
  flash[:notice] = "You are now signed out."
  redirect '/'
end

get '/thanks' do
  erb :thanks
end
