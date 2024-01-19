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
