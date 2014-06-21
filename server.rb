require 'sinatra'
require 'rubygems'
require 'pry'
require 'pg'

require_relative 'helpers.rb'

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

  if is_empty?(@first_name, @last_name, @talk_title) && is_dupe?(@first_name, @last_name, @talk_title)
    save_to_db(@first_name, @last_name, @talk_title)
    redirect '/'
  else

  end

end


















