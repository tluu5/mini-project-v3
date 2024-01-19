# sinatra-template

Use this repository to create new Sinatra apps. 

Optionally, to use `ActiveRecord` for database operations, add to the `app.rb`:

```ruby
require "sinatra/activerecord"
```

And in the `config/environment.rb` file add this code block:

```ruby
configure do
  # setup a database connection
  set(:database, { adapter: "sqlite3", database: "db/development.sqlite3" })
end
```
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

hi hi 
