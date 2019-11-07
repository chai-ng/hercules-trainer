require 'date'

def get_all_exercises
    exec_sql("SELECT * FROM exercises;")
end

def get_exercise exercise_id
    exec_sql("SELECT * FROM exercises WHERE exercise_id = #{exercise_id};").first
end

def delete_exercise exercise_id
    exec_sql("DELETE FROM exercise_sets WHERE exercise_id = #{exercise_id};")
    exec_sql("DELETE FROM exercises WHERE exercise_id = #{exercise_id};")
end

def get_exercise_progress user_id, exercise_id, interval = 'd', metric = 'reps', limit = 30
    # Metric = reps, weight, volume or time
    # Interval = group by daily, weekly, monthly OR no grouping
    progress = "SELECT user_id, "

    if interval == 'd'
        progress += "TO_CHAR(date_time :: DATE, 'dd Mon yy') AS date_clean"
    elsif interval == 'w'
        progress += "TO_CHAR(date_time :: DATE, 'ww yy') AS date_clean"
    elsif interval == 'm'
        progress += "TO_CHAR(date_time :: DATE, 'Mon yyyy') AS date_clean"
    else
        progress += "date_time AS date_clean"
    end

    if metric == 'weight'
        progress += ', MAX(weight) AS sum'
    elsif metric == 'volume'
        progress += ', SUM(reps * weight) AS sum'
    elsif metric == 'time'
        progress += ', SUM(duration_seconds) AS sum'
    else
        progress += ', SUM(reps) AS sum'
    end

    progress += " FROM exercise_sets WHERE user_id = #{user_id} AND exercise_id = #{exercise_id} GROUP BY date_clean, user_id ORDER BY date_clean DESC LIMIT #{limit};"
    progressData = exec_sql(progress).to_a
    output = {}

    if interval == 'w'
        progressData.each do |progress|
            output["Week " + progress["date_clean"].to_s] = progress["sum"].to_i
        end
    else
        progressData.each do |progress|
            output[progress["date_clean"].to_s] = progress["sum"].to_i
        end
    end

    return output
end

def get_exercise_id exercise_name
    return exec_sql("SELECT exercise_id FROM exercises WHERE exercise_name = '#{exercise_name}';").first["exercise_id"].to_i
end

def create_exercise exercise_name, primary_muscle_group, difficulty, measurement_type, description
    exec_sql("INSERT INTO exercises (exercise_name, primary_muscle_group, difficulty, measurement_type, description) VALUES ('#{exercise_name}','#{primary_muscle_group}',#{difficulty},'#{measurement_type}','#{description}');")
end

def update_exercise exercise_id, exercise_name, primary_muscle_group, difficulty, measurement_type, description
    exec_sql("UPDATE exercises SET exercise_name = '#{exercise_name}', primary_muscle_group = '#{primary_muscle_group}', difficulty = #{difficulty}, measurement_type = '#{measurement_type}', description = '#{description}' WHERE exercise_id = #{exercise_id};")
end

def create_rep_set user_id, exercise_id, date_time, reps, weight
    exec_sql("INSERT INTO exercise_sets (user_id, exercise_id, date_time, reps, weight) VALUES (#{user_id}, #{exercise_id}, '#{date_time}', #{reps}, #{weight});")
end

def create_time_set user_id, exercise_id, date_time, duration_seconds
    exec_sql("INSERT INTO exercise_sets (user_id, exercise_id, date_time, duration_seconds) VALUES (#{user_id}, #{exercise_id}, '#{date_time}', #{duration_seconds});")
end

def create_set user_id, exercise_id, date_time, reps, weight, duration_seconds
    exec_sql("INSERT INTO exercise_sets (user_id, exercise_id, date_time, reps, weight, duration_seconds) VALUES (#{user_id}, #{exercise_id}, '#{date_time}', #{reps}, #{weight}, #{duration_seconds});")
end

def get_top_users exercise_id, measurement_type, time_period = 7
    if measurement_type == 'time'
        exec_sql("SELECT user_id, TO_CHAR(date_time :: DATE, 'dd Mon yy') AS date_clean, SUM(duration_seconds) AS sum FROM exercise_sets WHERE date_time BETWEEN current_date - #{time_period - 1} AND current_date + 1 GROUP BY user_id, date_clean;").to_a
    else
        exec_sql("SELECT user_id, TO_CHAR(date_time :: DATE, 'dd Mon yy') AS date_clean, SUM(reps * weight) AS sum FROM exercise_sets WHERE date_time BETWEEN current_date - #{time_period - 1} AND current_date + 1 GROUP BY user_id, date_clean;")
    end

    # Return array, sorted by volume highest to lowest for each user
    # object {user_id, volume}

    # Get array of each users,
end