require 'date'

def get_workout_time user_id, time_interval = 7
    results = exec_sql("SELECT TO_CHAR(date_range :: DATE, 'd Mon') AS date_clean, SUM(duration_seconds) FROM (SELECT CAST (generate_series(CURRENT_DATE - #{time_interval - 1}, CURRENT_DATE + 1, INTERVAL '1 day') AS DATE) AS date_range) AS full_dates LEFT JOIN exercise_sets ON full_dates.date_range = CAST(exercise_sets.date_time AS DATE) WHERE user_id = $1 OR user_id IS NULL GROUP BY date_clean;",[user_id]).to_a
    output = {}
    results.each do |day|
        output[day["date_clean"]] = day["sum"]
    end
    return output
end

def get_muscle_group_time user_id, time_interval = 30
    results = exec_sql("SELECT primary_muscle_group, SUM(duration_seconds) FROM exercise_sets LEFT JOIN exercises ON exercise_sets.exercise_id = exercises.exercise_id WHERE user_id = $1 GROUP BY primary_muscle_group;",[user_id]).to_a
    output = {}
    results.each do |group|
        output[group["primary_muscle_group"]] = group["sum"]
    end
    return output
end

def get_user_exercises user_id
    exercises = exec_sql("SELECT exercise_id FROM exercise_sets WHERE user_id = $1 GROUP BY exercise_id;",[user_id]).to_a
    output = []
    exercises.each do |elem|
        output.push(elem.values().first.to_i)
    end
    return output
end