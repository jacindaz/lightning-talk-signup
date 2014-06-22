require 'sinatra'
require 'rubygems'
require 'pry'
require 'pg'
require 'sinatra/redirect_with_flash'
require 'sinatra/flash'

require_relative 'app/models/helpers'
enable :sessions
# helpers Sinatra::RedirectWithFlash

configure do
  set :views, 'app/views'
end

#ROUTES and VIEWS--------------------------------------------------------------------------------

get '/' do
  @all_talks = return_all_talks
  erb :index
end

get '/test' do
  @all_talks = return_all_talks
  erb :index2
end

post '/add_talk' do
  @first_name = params["firstname"]
  @last_name = params["lastname"]
  @talk_title = params["usertalktopic"]
  @description = params["talk_description"]

  if !is_empty?(@first_name, @last_name, @talk_title, @description) && !is_dupe?(@first_name, @last_name, @talk_title, @description)
    save_to_db(@first_name, @last_name, @talk_title, @description)
    redirect '/thanks'
  else
    flash[:notice] = "I'm sorry, your talk could not be saved."
    redirect '/'
  end
end

get '/thanks' do
  erb :thanks
end


















