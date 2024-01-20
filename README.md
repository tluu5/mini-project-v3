1> touch Rakefile
require './app'
require 'sinatra/activerecord/rake'

2> touch config/database.yml

development:
  adapter: sqlite3
  database: db/development.sqlite3

test:
  adapter: sqlite3
  database: db/test.sqlite3

3> bundle exec rake -T
Will test this setup

4> bundle exec rake db:create

5> bundle exec rake db:create_migration NAME=create_name_of_each_data_sets
(Don't put all data tables in one file)

6> bundle exec rake db:migrate
(Use only once. If you miss including a string, start a new codespace again)

find file: config/render-build.sh
add as last line: '''bundle exec rake db:migrate RACK_ENV=production'''

find file: config/render-start.sh
add as last line: '''bundle exec puma -C config/puma.rb'''

create file: config/puma.rb
'''
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

worker_timeout 3600 if ENV.fetch("RAILS_ENV", "development") == "development"

port ENV.fetch("PORT") { 3000 }

environment ENV.fetch("RAILS_ENV") { "production" } #development" }

pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }
'''

tmp/pids/
Create a tmp/pids/ if it do not already exist
'''
mkdir tmp
mkdir tmp/pids
'''

credentials:
Creat a temp directory, make a new rails app, copy config/master.key and config/credentials.yml.enc to the config/ directory. Make sure master.key is in .gitignore. Use/paste this master key during deployment at Render, where there would be an empty text field with a Generate button.
'''
mkdir temp
cd temp
rails new app
cp config/master.key ../config
cp config/credentials.yml.enc ../config
cd ..
rm -rf temp
'''

find file: config/environment.rb
'''
require "./app"

configure do
  # GitHub Pages and Render deployment
  set(:public_folder, "./")
end
# appdev support patches
require "appdev_support"

#set :database_file, 'config/database.yml'

AppdevSupport.config do |config|
  #config.action_dispatch = true;
  config.active_record = true;
  config.pryrc = :full
end
AppdevSupport.init
'''

find file: database.yml
'''
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>

development:
  <<: *default
  database: mini_project_dev #db/development.sqlite3

test:
  <<: *default
  database: mini_project_test #db/test.sqlite3

production:
  <<: *default
  url: <%= ENV["DATABASE_URL"] %>
  database: mini_project
  username: postgres
  password: <%= ENV["RAILS_MASTER_KEY"] %>
'''

find file: app.rb
add the require at the top
'''
require "sinatra"
require "sinatra/reloader"
require "sinatra/activerecord"
require './models/user'
require './models/tv_show'
require 'bcrypt'

# Configure the database connection
set :database_file, 'config/database.yml'

# Enable sessions
enable :sessions
'''

find Gemfile:
'''
source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.1"

gem "sinatra"
gem "sinatra-contrib"
gem "bcrypt"
gem "rackup"

# Use Puma as the app server
gem "puma" #, "~> 5.0"

gem "rake"
gem "sinatra-reloader"
gem "activesupport" 
gem 'activerecord'
gem "sinatra-activerecord"
gem "appdev_support"
gem "pg"

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "table_print"
end

group :development, :test do
  gem "grade_runner"
  gem "pry"
  #gem "sqlite3", "~> 1.4"
  #gem "pg"
end

group :test do
  gem "capybara"
  gem "draft_matchers"
  gem "rspec"
  gem "rspec-html-matchers"
  gem "webmock"
  gem "webdrivers"
  gem "i18n"
end

group :production do
  #gem "pg"
end
'''

find render.yml:
'''
databases:
  - name: mini_project
    databaseName: mini_project
    user: mini_project
    plan: free

services:
  - type: web
    plan: free
    name: mini_project
    runtime: ruby
    buildCommand: "./bin/render-build.sh"
    startCommand: "./bin/render-start.sh"
    envVars:
      - key: DATABASE_URL
        fromDatabase:
          name: mini_project
          property: connectionString
      - key: RAILS_MASTER_KEY
        sync: false
      - key: WEB_CONCURRENCY
        value: 2
'''

additional step for Render's Linux platform
From the terminal:
'''
bundle lock --add-platform x86_64-linux
bundle
'''

Then commit.

when setting up Blueprint at Render
Be sure to use your master.key value for the value of RAILS_MASTER_KEY

Development: from the terminal
Set up database:
'''
bundle exec rake db:create
bundle exec rake db:migrate
'''

Run from terminal:
'''
rackup
'''
or
'''
bin/dev
'''
