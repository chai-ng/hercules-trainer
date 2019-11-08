require 'sinatra'
require 'pg'
if settings.development?
  require 'pry'
  require 'sinatra/reloader'
  also_reload File.expand_path(__dir__, 'models/*')
end
require 'bcrypt'
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
require_relative 'models/exercises'

get '/' do
  # Load home page if user is logged in, or else redirect to login page
  @user = current_user
  if logged_in?
    redirect "/progress/#{@user["user_id"]}"
  end
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
    redirect "/progress/#{@user["user_id"]}"
  else
    redirect "/login/error"
  end
end

get '/login/error' do
  erb :login_error
end

get '/logout' do
  session[:user_id] = nil
  redirect '/login'
end

get '/users/new' do
  erb :new_user
end

post '/users/new' do
  create_user(params[:first_name], params[:last_name], params[:email], params[:password], params[:birth_year])
  @user = get_user(params[:email])
  session[:user_id] = @user["user_id"]
  redirect "/progress/#{@user["user_id"]}"
end

delete '/users/delete' do
  delete_user(params[:user_id])
  redirect "/"
end

get '/exercises' do
  @exercises = get_all('exercises')
  @user = current_user
  erb :exercises
end

get '/exercises/new' do
  redirect "/login" unless logged_in?
  @user = current_user
  erb :new_exercise
end

post '/exercises/new' do
  exercise_id = create_exercise(params[:exercise_name],params[:primary_muscle_group],params[:difficulty],params[:measurement_type],params[:description])
  redirect "/exercises"
end

post '/exercises/edit' do
  binding.pry
  update_exercise(params[:exercise_id],params[:exercise_name],params[:primary_muscle_group],params[:difficulty],params[:measurement_type], params[:description])
  redirect "/exercises/#{params[:exercise_id]}/d"
end

post '/exercises/delete' do
  delete_exercise(params[:exercise_id])
  redirect "/exercises"
end

get '/exercises/:exercise_id/:frequency' do
  @exercise = get_exercise(params[:exercise_id])
  @top_players = get_top_users(params[:exercise_id], @exercise["measurement_type"])
  if logged_in?
    @user = current_user
    @frequency = params[:frequency]
    @reps = get_exercise_progress(@user["user_id"],@exercise["exercise_id"],@frequency,'reps')
    @weight = get_exercise_progress(@user["user_id"],@exercise["exercise_id"],@frequency,'weight')
    @volume = get_exercise_progress(@user["user_id"],@exercise["exercise_id"],@frequency,'volume')
    @time = get_exercise_progress(@user["user_id"],@exercise["exercise_id"],@frequency,'time')
  end
  erb :exercise
end

get '/start/:exercise_id' do
  @user = current_user
  @exercise = get_exercise(params[:exercise_id])
  erb :track_workout
end

post '/start/:exercise_id' do
  @user = current_user
  create_set(@user["user_id"],params[:exercise_id],Time.now,params[:reps],params[:weight], params[:duration_seconds])
  redirect "/exercises/#{params[:exercise_id]}/d"
end

get '/progress/:user_id' do
  @user = current_user
  @total_workout_time = get_workout_time(@user["user_id"])
  @total_body_time = get_muscle_group_time(@user["user_id"])
  @user_exercises = get_user_exercises(@user["user_id"])
  erb :progress
end