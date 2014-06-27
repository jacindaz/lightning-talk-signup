require 'rubygems'
require 'sinatra'
require 'sinatra/flash'
require 'pg'

require_relative 'app/models/helpers'


configure do
  set :views, 'app/views'
  enable :sessions
end

#ROUTES and VIEWS--------------------------------------------------------------------------------

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

get '/thanks' do
  erb :thanks
end
