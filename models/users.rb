require_relative '../main.rb'
require 'BCrypt'
require 'PG'

def logged_in?
    return !!current_user
end

def current_user
    return get_user(session[:user_id].to_i)
end

def logout_user
    session[:user_id] = nil
end

def create_user first_name, last_name, email, password, birth_year
    hashed_password = BCrypt::Password.create(password)
    exec_sql("INSERT INTO users (first_name, last_name, email, hashed_password, birth_year) VALUES ('#{first_name}','#{last_name}', '#{email}', '#{hashed_password}', #{birth_year});")
    return exec_sql("SELECT user_id FROM users WHERE email = '#{email}';").first
end

def get_user search_value
    if search_value.class == Integer
        return exec_sql("SELECT * FROM users WHERE user_id = '#{search_value}';").first
    else
        return exec_sql("SELECT * FROM users WHERE email = '#{search_value}';").first
    end
end

def join_track user_id, track_id
    exec_sql("INSERT INTO user_tracks (user_id, track_id, date_started) VALUES (#{user_id}, #{track_id}, #{Time.now});")
end

def complete_track user_id, track_id
    exec_sql("UPDATE user_tracks SET date_completed = #{Time.now} WHERE user_id = #{user_id} AND track_id = #{track_id};")
end

def delete_user user_id
    exec_sql("DELETE FROM workout_sessions WHERE user_id = #{user_id};") # Include a join here for session_exercise_sets
    exec_sql("DELETE FROM user_tracks WHERE user_id = #{user_id};")
    exec_sql("DELETE FROM users WHERE user_id = #{user_id};")
    # should we also delete all of their workout history?
end