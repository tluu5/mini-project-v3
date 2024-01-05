require "sinatra"
require "sinatra/reloader"
require "sinatra/activerecord"
require './models/user'
require './models/tv_show'
require './config/environment'
require 'bcrypt'

# Configure the database connection
configure :development do
  set :database, 'sqlite3:mini_project_v3.db'
end

configure :production do
  # Set your production database configuration here
  # Example:
  # set :database, 'postgres://username:password@localhost/mydatabase'
end

# Enable sessions
enable :sessions

get("/") do
  "
  <h1>Welcome to your Sinatra App!</h1>
  <p>Define some routes in app.rb</p>
  "
end
