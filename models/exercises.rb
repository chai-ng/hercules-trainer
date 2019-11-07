require 'date'

# # Show user specific workouts
# def get_user_sessions user_id
#     exec_sql("SELECT * FROM workout_sessions WHERE user_id = #{user_id};")
# end

# def get_session session_id
#     exec_sql("SELECT * FROM workout_sessions WHERE session_id = #{session_id};")
# end

# def start_session user_id, workout_id = nil
#     if workout_id == nil
#         exec_sql("INSERT INTO workout_sessions (date, start_time, user_id) VALUES ('#{Date.today}', '#{Time.now.to_s(:db)}',#{user_id});")
#     else
#         exec_sql("INSERT INTO workout_sessions (date, start_time, user_id, workout_id) VALUES ('#{Date.today}', '#{Time.now.to_s(:db)}',#{user_id},#{workout_id}); ")
#     end
# end

# def complete_session session_id
# end

def get_all_exercises
    exec_sql("SELECT * FROM exercises;")
end

def get_exercise exercise_id
    exec_sql("SELECT * FROM exercises WHERE exercise_id = #{exercise_id};").first
end

def get_exercise_progress user_id, exercise_id
    exec_sql("SELECT date_time, reps, weight, duration_seconds FROM exercise_sets WHERE user_id = #{user_id} AND exercise_id = #{exercise_id};").to_a
end

def get_workout_id workout_name
    return exec_sql("SELECT workout_id FROM workouts WHERE workout_name = '#{workout_name}';").first["workout_id"].to_i
end

def get_exercise_id exercise_name
    return exec_sql("SELECT exercise_id FROM exercises WHERE exercise_name = '#{exercise_name}';").first["exercise_id"].to_i
end

def get_user_workouts user_id
    exec_sql("SELECT * FROM workouts WHERE created_user_id = #{user_id};")
end

def get_workout_exercises workout_id
    exec_sql("SELECT * FROM exercises INNER JOIN workouts_exercises ON exercises.exercise_id = workouts_exercises.exercise_id WHERE workout_id = #{workout_id};")
end

def create_workout workout_name, primary_muscle_group, exercise_array
    exec_sql("INSERT INTO workouts (workout_name, primary_muscle_group) VALUES ('#{workout_name}','#{primary_muscle_group};")
    
    # Fetch the workout_id
    workout_id = get_workout_id(workout_name)
    
    # Insert each exercise into the array
    exercise_array.each_with_index do |exercise_id, index|
        exec_sql("INSERT INTO workouts_exercises (workout_id, exercise_id, order) VALUES (#{workout_id}, #{exercise_id}, #{index});")
    end
end

def create_exercise exercise_name, primary_muscle_group, difficulty, measurement_type, description
    exec_sql("INSERT INTO exercises (exercise_name, primary_muscle_group, difficulty, measurement_type, description) VALUES ('#{exercise_name}','#{primary_muscle_group}',#{difficulty},'#{measurement_type}','#{description}');")
end

def create_entry user_id, exercise_id, date_time, reps, weight
    exec_sql("INSERT INTO exercise_sets (user_id, exercise_id, date_time, reps, weight) VALUES (#{user_id}, #{exercise_id}, '#{date_time}', #{reps}, #{weight});")
end