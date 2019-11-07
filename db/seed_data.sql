-- Create users
INSERT INTO users (first_name, last_name, email, birth_year) VALUES ('Chai', 'Ng', 'chai.ng@gmail.com', 1995);


-- Create example track
INSERT INTO tracks (track_type, name, description, source) VALUES ('arms', 'Handstand', 'Get to your first hand stand in 30 days.', 'https://www.nerdfitness.com/blog/a-beginners-guide-to-handstands/');

-- Create exercises
INSERT INTO exercises (exercise_name, image_url, description, primary_muscle_group, difficulty, measurement_type) VALUES ('Quadruped Rocking', 'https://www.nerdfitness.com/wp-content/uploads/2018/08/q-rock-1.gif', 'Start on your hands and knees in a quadruped position. Rock forwards and backwards until you feel the weight balanced in the right spot, your knucles.', 'Arms', 1, 'time');

INSERT INTO exercises (exercise_name, image_url, description, primary_muscle_group, difficulty, measurement_type) VALUES ('Hollow Body', 'https://www.nerdfitness.com/wp-content/uploads/2018/08/hollow-body-1.gif', 'Rock your body forward and back slightly from the upper back to the lower back. Head and feet stay off the ground. If you are stable then you should move as one unit. For a more difficult challenge, have your arms extended overhead.', 'Arms', 1, 'time');

INSERT INTO exercises (exercise_name, image_url, description, primary_muscle_group, difficulty, measurement_type) VALUES ('Crow Pose', 'https://www.nerdfitness.com/wp-content/uploads/2018/08/crow-pose-9.gif', 'Rock forward and gradually transition the weight from your feet to your hands. Take things slow and easy.', 'Arms', 2, 'time');

INSERT INTO exercises (exercise_name, image_url, description, primary_muscle_group, difficulty, measurement_type) VALUES ('Wall Walk', 'https://www.nerdfitness.com/wp-content/uploads/2018/08/wall-walk-1.gif', 'Start off at a push-up position, and gradually walk feet up the wall. Warning: Make sure you have enough energy to walk back down safety and don''t walk too close to the wall!', 'Arms', 2, 'time');

-- Create example workout
INSERT INTO workouts (workout_name, primary_muscle_group, track_id, track_order) VALUES ('Week 1 Handstands', 'Arms', 1,1);
INSERT INTO workouts (workout_name, primary_muscle_group, track_id, track_order, unlock_exercise_id, unlock_exercise_criteria, unlock_exercise_value) VALUES ('Week 2 Handstands', 'Arms', 1,1,2,'time', 60);

INSERT INTO workouts_exercises (workout_id, exercise_id, workout_order) VALUES (1,1,1);
INSERT INTO workouts_exercises (workout_id, exercise_id, workout_order) VALUES (1,2,2);
INSERT INTO workouts_exercises (workout_id, exercise_id, workout_order) VALUES (2,3,1);
INSERT INTO workouts_exercises (workout_id, exercise_id, workout_order) VALUES (2,4,2);

-- Create relationship of user with track
INSERT INTO user_tracks (user_id, track_id, date_started) VALUES (1, 1, '2019-11-01');

-- Create workout session
INSERT INTO workout_sessions (date, start_time, end_time, user_id, workout_id, track_id) VALUES ('2019-11-01', '2019-11-01 19:10:25', '2019-11-01 18:00:00',1,1,1);

INSERT INTO sessions_exercise_sets (session_id, exercise_id, duration_seconds) VALUES (1, 1, 30);
INSERT INTO sessions_exercise_sets (session_id, exercise_id, duration_seconds) VALUES (1, 1, 35);
INSERT INTO sessions_exercise_sets (session_id, exercise_id, duration_seconds) VALUES (1, 1, 40);

INSERT INTO sessions_exercise_sets (session_id, exercise_id, duration_seconds) VALUES (1, 2, 30);
INSERT INTO sessions_exercise_sets (session_id, exercise_id, duration_seconds) VALUES (1, 2, 35);
INSERT INTO sessions_exercise_sets (session_id, exercise_id, duration_seconds) VALUES (1, 2, 40);

-- Create 30 days of push up progress
-- 1. Create the two types of push-ups
INSERT INTO exercises (exercise_name, description, primary_muscle_group, difficulty, measurement_type) VALUES ('Push Up (on toes)', 'Talk about good form here.', 'Arms', 2, 'reps');
INSERT INTO exercises (exercise_name, description, primary_muscle_group, difficulty, measurement_type) VALUES ('Push Up (on knees)', 'Talk about good form here.', 'Arms', 1, 'reps');

-- 2. Create the workout sessions (every other day)

INSERT INTO workout_sessions (date, start_time, end_time, user_id) VALUES ('2019-11-01', '2019-11-01 19:10:25', '2019-11-01 18:00:00',6);
INSERT INTO workout_sessions (date, start_time, end_time, user_id) VALUES ('2019-11-02', '2019-11-01 19:10:25', '2019-11-01 18:00:00',6);
INSERT INTO workout_sessions (date, start_time, end_time, user_id) VALUES ('2019-11-03', '2019-11-01 19:10:25', '2019-11-01 18:00:00',6);
INSERT INTO workout_sessions (date, start_time, end_time, user_id) VALUES ('2019-11-04', '2019-11-01 19:10:25', '2019-11-01 18:00:00',6);
INSERT INTO workout_sessions (date, start_time, end_time, user_id) VALUES ('2019-11-05', '2019-11-01 19:10:25', '2019-11-01 18:00:00',6);
INSERT INTO workout_sessions (date, start_time, end_time, user_id) VALUES ('2019-11-06', '2019-11-01 19:10:25', '2019-11-01 18:00:00',6);
INSERT INTO workout_sessions (date, start_time, end_time, user_id) VALUES ('2019-11-07', '2019-11-01 19:10:25', '2019-11-01 18:00:00',6);

-- 3. Create the exercises done for each session

INSERT INTO sessions_exercise_sets (session_id, exercise_id, reps) VALUES (2, 5, 10);
INSERT INTO sessions_exercise_sets (session_id, exercise_id, reps) VALUES (2, 5, 10);
INSERT INTO sessions_exercise_sets (session_id, exercise_id, reps) VALUES (2, 5, 10);

INSERT INTO sessions_exercise_sets (session_id, exercise_id, reps) VALUES (3, 5, 12);
INSERT INTO sessions_exercise_sets (session_id, exercise_id, reps) VALUES (3, 5, 12);
INSERT INTO sessions_exercise_sets (session_id, exercise_id, reps) VALUES (3, 5, 12);

INSERT INTO sessions_exercise_sets (session_id, exercise_id, reps) VALUES (4, 6, 5);
INSERT INTO sessions_exercise_sets (session_id, exercise_id, reps) VALUES (4, 5, 12);
INSERT INTO sessions_exercise_sets (session_id, exercise_id, reps) VALUES (4, 5, 12);

INSERT INTO sessions_exercise_sets (session_id, exercise_id, reps) VALUES (5, 6, 10);
INSERT INTO sessions_exercise_sets (session_id, exercise_id, reps) VALUES (5, 5, 12);
INSERT INTO sessions_exercise_sets (session_id, exercise_id, reps) VALUES (5, 5, 12);

INSERT INTO sessions_exercise_sets (session_id, exercise_id, reps) VALUES (6, 6, 12);
INSERT INTO sessions_exercise_sets (session_id, exercise_id, reps) VALUES (6, 5, 12);
INSERT INTO sessions_exercise_sets (session_id, exercise_id, reps) VALUES (6, 5, 12);

INSERT INTO sessions_exercise_sets (session_id, exercise_id, reps) VALUES (7, 6, 12);
INSERT INTO sessions_exercise_sets (session_id, exercise_id, reps) VALUES (7, 6, 12);
INSERT INTO sessions_exercise_sets (session_id, exercise_id, reps) VALUES (7, 5, 12);

INSERT INTO sessions_exercise_sets (session_id, exercise_id, reps) VALUES (8, 6, 12);
INSERT INTO sessions_exercise_sets (session_id, exercise_id, reps) VALUES (8, 6, 12);
INSERT INTO sessions_exercise_sets (session_id, exercise_id, reps) VALUES (8, 6, 12);