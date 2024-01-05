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

get '/' do
  erb :index
end

# Route to handle user logout
post '/logout' do
  # Clear the user sesion
  session.clear

  # Redirect to the index page
  redirect '/'
end

get '/register' do
  erb :register
end

post '/register' do
  @user = User.new(params)
  if @user.save
    session[:user_id] = @user.id
    redirect '/dashboard'
  else
    @error_messages = @user.errors.full_messages
    erb :register
  end
end

get '/login' do
  erb :login
end

post '/login' do
  @user = User.find_by(email: params[:email])
  if @user && BCrypt::Password.new(@user.password) == params[:password]
    session[:user_id] = @user.id
    redirect '/dashboard'
  else
    @error_message = 'Invalid email or password'
    erb :login
  end
end

get '/dashboard' do

  # Retrieve the logged-in user
  @user = User.find(session[:user_id])

  # Retrieve all TV shows from the database
  @tv_shows = TvShow.all

  erb :dashboard
end

# Route to display the form for adding a new show
get '/new_show' do
  erb :new_show
end

# Route to handle the form submission and create a new show
post '/new_show' do

  # Create a new TV show with the provided parameters
  @show = TvShow.new(
    title: params[:title],
    network: params[:network],
    release_date: params[:release_date],
    description: params[:description]
  )

  if @show.save && @user
    session[:user_id] = @user.id
    redirect '/dashboard'
  else
    @error_messages = @show.errors.full_messages
    erb :new_show
  end
end

# Route to display a specific TV show
get '/shows/:id' do

  # Find the TV show by ID
  @show = TvShow.find(params[:id])

  # Find the user who posted the show
  @user = User.find(@show.user_id)

  erb :show
end

# Route to display the edit form for a specific TV show
get '/edit/:id' do

  # Find the TV show by ID
  @show = TvShow.find(params[:id])

  erb :edit
end

# Route to handle the form submission and update a show
post '/edit/:id' do

  # Find the show by ID and user ID
  @show = TvShow.find_by(id: params[:id])

  # Update the TV show with the provided parameters
  @show.title = params[:title]
  @show.network = params[:network]
  @show.release_date = params[:release_date]
  @show.description = params[:description]

  if @show.save && @user
    session[:user_id] = @user.id
    redirect '/dashboard'
  else
    @error_messages = @show.errors.full_messages
    erb :edit
  end
end

# Route to handle deleting a specific TV show
get '/delete/:id' do

  # Find the TV show by ID
  @show = TvShow.find(params[:id])

  # Delete the TV show from the database 
  @show.destroy

  # Redirect back to the dashboard
  redirect '/dashboard'
end
