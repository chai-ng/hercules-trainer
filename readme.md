# Hercules App

## Introduction
Hercules - Your Strength Training Companion

Born out of a personal need to better track my strength training journey (and rehab), in a visual way. This app aims to help users:
- Track their strength training, by time, reps and weight 
- Create their own exercises when they don't find one that fits
- Compete against others to top the Hercules leaderboards

Demo here: https://hercules-training.herokuapp.com/

## Feature backlog
- Create 'parent' exercises to better structure variations of exercises (e.g. squats and planks with many variations)
- Users can choose different modes to beat their 'personal bests', such as time-based, weight-based or rep-based
- Create 'equipment' table to better show
- Build a workout (multiple exercises)
- Include search and filter functions to find activities
- Provide smart recommendations on exercises to motivate users (e.g. based on supporting exercises, increasing frequency, increasing weight, increasing difficulty by changing form)
- User can compare their progress / strength to 'others like you' for motivation

## Database structure
| Table | Fields | Purpose |
|-------|--------|---------|
| Users | user_id, name, age, email, password | Store metadata on the user 
| Exercises | exercise_id, primary_muscle_group, difficulty, image_url, description | Library of all exercises and how they map to the muscle groups
| Exercise-Sets | user_id, exercise_id, reps, weight, duration_seconds | Many-to-many relationship map for users, exercises and sets

### Database relationships
- One user can have multiple exercises
- One exercise can have multiple sets
- Each set can only belong to one user and one exercise 

## Technology used
- [Chartkick - Ruby graphing library](https://chartkick.com/)
- [Materialize UI framework](https://materializecss.com/)

## Learnings
- Use wireframes to visualise your routes, build the flow of your app and help to cut away the unnecessary pages BEFORE you touch the code
- Building an MVP means building a SHIPPABLE / USABLE product that users can still get value of
  - Fake MVP: Build all the back-end features first, then touch front-end
  - Real MVP: Cut down the feature scope and app complexity to a valuable use case first and get that working
- Be aware of the complexity that might be included later, but avoid building the complex tables up front when you might not use them yet (refer above)
- Dates are hard, charts with dates are harder - use plugins
- Important to be able to read documentation of libraries / plugins that are being used to be able to debug errors - could be as simple as syntax
- In the absence of Active Records, SQL queries is your best friend to transform data into points you need