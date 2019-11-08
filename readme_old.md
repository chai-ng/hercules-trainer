# Hercules App

## Introduction
"Duolingo for strength training"

Born out of my ACL surgery and need to keep track of my rehab progress, alongside my long standing goals to do a handstand and pull-up.

Why not gamify the experience to look closer to a game, with skill trees, XP and progression built into this.

### Existing apps
- [ACL Rehab on iOS](https://apps.apple.com/us/app/acl-rehab/id1006387276)
- [My Knee Injury on iOS](https://www.myinjuryapps.com/my-knee-injury)

## What's the problem and why should we care?
Average of 10k ACL reconstructions in Australia each year, with less than 20% achieving comparable knee performance to someone without surgery.

Why? Resource-strapped public systems make it difficult to dedicate time to rehab patients beyond 'functional', lack of awareness from patients on the importance of rehab to get more functionality and lifetime value from their knee.

## Use cases and features
MVP
- Users can track their strength building progress on exercises, or tracks in a visual way
- Users can jump on popular 'tracks', or build their own workouts
- Users can start their 'track', with built-in timer and ability to capture input of their sets / reps easily
- Users can customise the order of the exercises in the workout
- Scope: ACL rehab and handstands

Backlog
- Users can get smart recommendations to increase performance of an exercise, muscle group or track (e.g. based on supporting exercises, increasing frequency, increasing weight, increasing difficulty by changing form)
- Users receive reminders when track / exercise / muscle group has been neglected for too long
- Users can choose different modes to set their 'personal bests', such as time-based, weight-based or rep-based
- User can compare their progress / strength to 'others like you' for motivation
- User can export exercise history and data

## Database structure
| Table | Fields | Purpose |
|-------|--------|---------|
| Users | user_id, name, age, weight, height, email, password | Store metadata on the user 
| Tracks | track_id, type, name, description, (source) | Roll-up version of workouts, grouped by progression tracks
| Workouts | workout_id, (track_id), (creator_user_id), (order), (goal) | Proposed workout sessions from pre-defined progression tracks or user-created workouts
| Exercises | exercise_id, muscle_group, difficulty, image_url, description | Library of all exercises and how they map to the muscle groups and progression tracks
| User-Tracks | user_id, track_id | Many-to-many relationship map for users and their current tracks
| Workout-Exercise Joiner | workout_id, exercise_id | Joiner table for the many-to-many relationship between workouts, exercises and users
| Workout-Exercise-Users | session_id, user_id, track_id, workout_id, exercise_id, sets, reps, weight, duration | Store each workout session for the user to be visualised later

### Database relationships
- One user can have multiple tracks
- One track can have multiple workouts
- One exercise can belong to multiple workouts and tracks
- Each session can only belong to one user, one track, one workout and one exercise 

## Technology used
- [Chartkick - Ruby graphing library](https://chartkick.com/)
- [WGER REST API - Library of exercises](https://wger.de/en/software/api)
- [exercise by davejt - Library of exercises](https://github.com/davejt/exercise)
- [Elasticsearch](https://github.com/elastic/elasticsearch-ruby)
- [Google Fitness API (for inspiration)](https://developers.google.com/android/reference/com/google/android/gms/fitness/package-summary)
- [Materialize UI framework](https://materializecss.com/)

## User flows and screenshots
- Login page
- Home page for user: Current track and exercise progress, with progress by...
  - Sessions
  - Progression track
  - Exercises
    - Individual exercise chart over time
    - Test personal best
      - Select exercise, list most recent
      - Select mode (time-based, weight-based, reps-based)
      - Start and key in individual exercise best
- Progression tracks: List all progression tracks
  - Single progression track view: List all workouts involved and criteria to pass this
    - Single workout view: View all exercises involved, proposed reps and criteria involved
- Workout session
  - Preparation: List of exercises, proposed sets and reps for each
  - In workout, for each set:
    - Timer or Reps / Weights to input
  - Completion: Celebration of progress
- Create workout:
  - Browse exercise library
  - Add exercise
  - Review order

## Key progress visualisations
- Max volume (reps * weight)
- Max reps in 1 minute
- Max reps till exhaustion
- Max one rep weight
- Max time (e.g. planks, handstands)

## CVP focus options
- Progression: Focus on machine-exercises
- Body weight records: Focus on daily, no-equipment body weight exercises and to beat the record on this in different forms
  - Example: Planks, squats, push-ups, jumping jacks