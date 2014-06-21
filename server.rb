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
  @name = params[:username]
  @topic = params[:usertalktopic]
  @all_talks = return_all_talks

  erb :index
end

post '/add_talk' do
  @first_name = params["firstname"]
  @last_name = params["lastname"]
  @talk_title = params["usertalktopic"]

  if !is_empty?(@first_name, @last_name, @talk_title) && !is_dupe?(@first_name, @last_name, @talk_title)
    save_to_db(@first_name, @last_name, @talk_title)
    redirect '/thanks'
  else
    flash[:notice] = "I'm sorry, your talk could not be saved."
    redirect '/'
  end
end

get '/thanks' do
  erb :thanks
end


















