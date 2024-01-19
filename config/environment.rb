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
