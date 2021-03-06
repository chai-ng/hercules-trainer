require 'date'

def get_all_exercises
    exec_sql("SELECT * FROM exercises;")
end

def get_exercise exercise_id
    exec_sql("SELECT * FROM exercises WHERE exercise_id = $1;", [exercise_id]).first
end

def delete_exercise exercise_id
    exec_sql("DELETE FROM exercise_sets WHERE exercise_id = $1;", [exercise_id])
    exec_sql("DELETE FROM exercises WHERE exercise_id = $1;", [exercise_id])
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

    progress += " FROM exercise_sets WHERE user_id = $1 AND exercise_id = $2 GROUP BY date_clean, user_id ORDER BY date_clean DESC LIMIT $3;"
    progressData = exec_sql(progress,[user_id, exercise_id, limit]).to_a
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
    return exec_sql("SELECT exercise_id FROM exercises WHERE exercise_name = $1;", [exercise_name]).first["exercise_id"].to_i
end

def create_exercise exercise_name, primary_muscle_group, difficulty, measurement_type, description
    exec_sql("INSERT INTO exercises (exercise_name, primary_muscle_group, difficulty, measurement_type, description) VALUES ($1, $2, $3, $4, $5);",[exercise_name,primary_muscle_group,difficulty,measurement_type, description])
end

def update_exercise exercise_id, exercise_name, primary_muscle_group, difficulty, measurement_type, description
    exec_sql("UPDATE exercises SET exercise_name = $1, primary_muscle_group = $2, difficulty = $3, measurement_type = $4, description = $5 WHERE exercise_id = $6;",[exercise_name, primary_muscle_group, difficulty, measurement_type, description, exercise_id])
end

def create_rep_set user_id, exercise_id, date_time, reps, weight
    exec_sql("INSERT INTO exercise_sets (user_id, exercise_id, date_time, reps, weight) VALUES (#{user_id}, #{exercise_id}, '#{date_time}', #{reps}, #{weight});")
end

def create_time_set user_id, exercise_id, date_time, duration_seconds
    exec_sql("INSERT INTO exercise_sets (user_id, exercise_id, date_time, duration_seconds) VALUES ($1, $2, $3, $4);",[user_id, exercise_id, date_time, duration_seconds])
end

def create_set user_id, exercise_id, date_time, reps, weight, duration_seconds
    exec_sql("INSERT INTO exercise_sets (user_id, exercise_id, date_time, reps, weight, duration_seconds) VALUES ($1, $2, $3, $4, $5, $6);",[user_id, exercise_id, date_time, reps, weight, duration_seconds])
end

def get_top_users exercise_id, measurement_type = 'reps', time_period = 7
    # Find the most reps / time for a given day for each user, find the max for each user
    if measurement_type == 'time'
        exec_sql("SELECT user_summary.user_id, user_summary.first_name, MAX(user_summary.time) FROM (SELECT users.user_id, first_name, TO_CHAR(date_time :: DATE, 'dd Mon yy') AS date_clean, MAX(duration_seconds) AS time FROM exercise_sets INNER JOIN users ON exercise_sets.user_id = users.user_id WHERE date_time BETWEEN current_date - #{time_period -1} AND current_date + 1 AND exercise_id = $1 GROUP BY users.user_id, first_name, date_clean) AS user_summary GROUP BY user_summary.user_id, user_summary.first_name ORDER BY max DESC;", [exercise_id]).to_a
    else
        exec_sql("SELECT user_summary.user_id, user_summary.first_name, MAX(user_summary.volume) FROM (select users.user_id, first_name, TO_CHAR(date_time :: DATE, 'dd Mon yy') AS date_clean, SUM(reps * weight) AS volume FROM exercise_sets INNER JOIN users ON exercise_sets.user_id = users.user_id WHERE date_time BETWEEN current_date - #{time_period -1} AND current_date + 1 AND exercise_id = $1 GROUP BY users.user_id, first_name, date_clean) AS user_summary GROUP BY user_summary.user_id, user_summary.first_name ORDER BY max DESC;",[exercise_id]).to_a
    end
end