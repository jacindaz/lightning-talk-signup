require 'rubygems'
require 'sinatra'
require 'rack-flash'
require 'sinatra/redirect_with_flash'
require 'pg'


require_relative 'app/models/helpers'
enable :sessions
use Rack::Flash
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

  is_empty = !is_empty?(@first_name, @last_name, @talk_title, @description)
  is_dupe = !is_dupe?(@first_name, @last_name, @talk_title, @description)

  if is_empty && is_dupe
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


















