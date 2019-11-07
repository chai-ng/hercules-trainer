require 'sinatra'
require 'PG'
if settings.development?
  # require 'sinatra/reloader'
  # also_reload File.expand_path(__dir__, 'models/*')
  require 'pry'
end
require 'BCrypt'
require 'date'
require 'groupdate'
require 'chartkick'
enable :sessions

def exec_sql command
  conn = PG.connect(ENV['DATABASE_URL'] || {dbname: "hercules"})
  results = conn.exec(command)
  conn.close
  return results
end

def get_all table
  return exec_sql("SELECT * FROM #{table};").to_a
end

require_relative 'models/users'
require_relative 'models/progress'
require_relative 'models/workouts'

get '/' do
  # Load home page if user is logged in, or else redirect to login page
  redirect '/login' unless logged_in?
  @user = current_user
  erb :index
end

get '/login' do
  # Get user to log in
  erb :login
end

post '/login' do
  # Check if user exists
  @user = get_user(params[:email])
  if @user == nil
    redirect "/login/error"
  end

  # check if password matches
  password = BCrypt::Password.new(@user["hashed_password"])
  if password == params[:password] && @user != nil
    session[:user_id] = @user["user_id"]
    redirect "/"
  else
    redirect "/login/error"
  end
end

get '/login/error' do
  erb :login_error
end

delete '/logout' do
  session[:user_id] = nil
  redirect '/login'
end

get '/users/user_id' do
  # Show user details
  erb :user
end

get '/users/new' do
  erb :new_user
end

post '/users/new' do
  # Create new user
  create_user(params[:first_name], params[:last_name], params[:email], params[:password], params[:birth_year])
  redirect "/"
end

delete '/users/delete' do
# Delete selected user
  delete_user(params[:user_id])
  redirect "/login"
end

get '/exercises' do
  @exercises = get_all('exercises')
  @user = current_user
  erb :exercises
end

get '/exercises/new' do
  @user = current_user
  erb :new_exercise
end

post '/exercises/new' do
  exercise_id = create_exercise(params[:exercise_name],params[:primary_muscle_group],params[:difficulty],params[:measurement_type],params[:description])
  redirect "/exercises"
end

get '/exercises/start/:exercise_id' do
  @user = current_user
  @exercise = get_exercise(params[:exercise_id])
  @progress = get_exercise_progress(@user["user_id"],@exercise["exercise_id"]).to_a
  erb :start_workout
end

get '/live_workout/:exercise_id' do
  @user = current_user
  @exercise = get_exercise(params[:exercise_id])
  erb :live_workout
end

post '/live_workout/:exercise_id' do
  create_entry(current_user["user_id"],params[:exercise_id],Time.now,params[:reps],params[:weight])
  redirect "/exercises/start/#{params[:exercise_id]}"
end

get '/progress/:user_id' do
  # View current progress across tracks, workouts, sessions and exercises
  erb :progress
end

# Retired functions

get '/workouts' do
  @workouts = get_all('workouts')
  @user = current_user
  erb :workouts
end

get '/workouts/user/:user_id' do
  @user = current_user
  @workouts = get_user_workouts(@user["user_id"])
  erb :workouts
end

get '/workouts/:workout_id' do
  @exercises = get_all_exercises(params[:workout_id])
  erb :workout
end

get '/workouts/new' do
  @user = current_user
  # Create a new workout
  erb :new_workout
end

post '/workouts/new' do
  create_workout(params[:workout_name],params[:primary_muscle_group], params[:splat].split('.'))
  redirect '/workouts'
end