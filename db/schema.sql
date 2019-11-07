CREATE DATABASE hercules;

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    email TEXT,
    hashed_password TEXT,
    birth_year INTEGER
);

CREATE TABLE tracks (
    track_id SERIAL PRIMARY KEY,
    track_type TEXT,
    name TEXT,
    description TEXT,
    source TEXT
);

CREATE TABLE exercises (
    exercise_id SERIAL PRIMARY KEY,
    exercise_name TEXT,
    image_url TEXT,
    primary_muscle_group TEXT,
    difficulty INTEGER,
    measurement_type TEXT,
    description TEXT,
);

CREATE TABLE workouts (
    workout_id SERIAL PRIMARY KEY,
    workout_name TEXT,
    primary_muscle_group TEXT,
    created_user_id INTEGER REFERENCES users,
    track_id INTEGER REFERENCES tracks,
    track_order INTEGER,
    unlock_exercise_id INTEGER REFERENCES exercises,
    unlock_exercise_criteria TEXT,
    unlock_exercise_value INTEGER
);

-- CREATE TABLE user_tracks (
--     user_id INTEGER REFERENCES users,
--     track_id INTEGER REFERENCES tracks,
--     date_started DATE,
--     date_completed DATE
-- );

CREATE TABLE workouts_exercises (
    workout_id INTEGER REFERENCES workouts,
    exercise_id INTEGER REFERENCES exercises,
    workout_order INTEGER
);

CREATE TABLE workout_sessions (
    session_id SERIAL PRIMARY KEY,
    date DATE,
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    user_id INTEGER REFERENCES users,
    workout_id INTEGER REFERENCES workouts,
    track_id INTEGER REFERENCES tracks
);

CREATE TABLE sessions_exercise_sets (
    session_id INTEGER REFERENCES workout_sessions,
    exercise_id INTEGER REFERENCES exercises,
    duration_seconds INTEGER,
    reps INTEGER,
    weight INTEGER
);

CREATE TABLE exercise_sets (
    user_id INTEGER REFERENCES users,
    exercise_id INTEGER REFERENCES exercises,
    date_time TIMESTAMP,
    duration_seconds INTEGER,
    reps INTEGER,
    weight INTEGER
);
