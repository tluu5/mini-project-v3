require "./app"
require "active_record"

configure do
  # GitHub Pages and Render deployment
  set(:public_folder, "./")
end

configure :development do
  # Configure the database connection
  set :database, 'sqlite3:mini_project_v3.db'
  # we would also like a nicer error page in development
  require "better_errors"
  require "binding_of_caller"

  # need this configure for better errors
  use(BetterErrors::Middleware)
  BetterErrors.application_root = __dir__
  BetterErrors::Middleware.allow_ip!("0.0.0.0/0.0.0.0")

  # appdev support patches
  require "appdev_support"

  AppdevSupport.config do |config|
    # config.action_dispatch = true;
    # config.active_record = true;
    config.pryrc = :full
  end
  AppdevSupport.init
end

#configure :production do
  # Set your production database configuration here
  # Example:
  # set :database, 'postgres://username:password@localhost/mydatabase'
#end
