library(dplyr)
library(dbplyr)
library(RSQLite)


file.exists("db.sqlite3") #zum testen ob die File überhaupt vorhanden ist. Kann später raus!
conn <- DBI::dbConnect(RSQLite::SQLite(), "db.sqlite3") #Definition der COnnection von der SQLitedatei "db.sqlite3" mit der Variable "verbindung

# Write the dataset into a table 
dbListTables(conn)

# get query to all tables
athletes_workout = dbGetQuery(conn, "SELECT * FROM athletes_workout")
athletes_athletes = dbGetQuery(conn, "SELECT * FROM athletes_athletes")
athletes_workout_data = dbGetQuery(conn, "SELECT * FROM athletes_workout_data")

#bring all data into one dataframe 
#merge athlethes_workout and athletes_workout_data
workout_and_workout_data = (right_join(athletes_workout, athletes_workout_data, by = c("id" ="workout_id")))
#merge athletes_athletes and workout_and_workout_data into full_dataset
full_dataset = (right_join(athletes_athletes, workout_and_workout_data, by = c("id" ="athlete_id")))
#check if the dataset athletes_and_workout_data contains all variables
#print(full_dataset)


#ALL WORKOUTS OF A SPECIFIC ATHLET

name = "Daniel"
colums_for_all_workouts_specific_athlete = select(full_dataset, first_name, last_name, description, start, end, date)
all_workouts_specific_athlete = colums_for_all_workouts_specific_athlete[colums_for_all_workouts_specific_athlete$first_name == name,]
#check if the dataframe gives all_workouts_specific_athlete
print(all_workouts_specific_athlete)

#AVERAGE OVER TRAINING DURATION OF A CERTAIN ATHLETE OVER ALL TRAININGS 

training_times = select(all_workouts_specific_athlete, date, start, end)
#print((select(all_workouts_specific_athlete, date, start, end)))

sum_training_duration = 0
counter=0

for(i in 1:nrow(training_times)) {       # for-loop over rows
  start_time_training = paste(toString(training_times$date[i]), toString(training_times$start[i]))
  end_time_training = paste(toString(training_times$date[i]), toString(training_times$end[i]))
  sum_training_duration = sum_training_duration + get_duration_of_training(start_time = start_time_training, end_time = end_time_training)
  counter=i
}

get_duration_of_training <- function(start_time, end_time) {
  return(difftime(end_time, start_time, units = "mins"))
}
#print(sum_training_duration)
average_training_duration= sum_training_duration/counter

#print the sentence 
#print(paste0("The average training duration of the athlet over all trainings is: ",toString(average_training_duration)))
print(sprintf("The average training duration of the athlet over all trainings is: %s min",toString(average_training_duration)))

#AVERAGE OVER TRAINING DURATION OF A SPECIFIC TRAINING OF AN ATHLETE 

description = "Joggen"
specific_workout_of_an_athlete = all_workouts_specific_athlete[all_workouts_specific_athlete$description == description,]

#check if the dataframe gives all_workouts_specific_athlete
print(specific_workout_of_an_athlete)

training_times_specific_workout = select(specific_workout_of_an_athlete, date, start, end)

sum_specific_training_duration = 0
counter_specific_training=0

for(o in 1:nrow(training_times_specific_workout)) {       # for-loop over rows
  start_time_specific_training = paste(toString(training_times_specific_workout$date[o]), toString(training_times_specific_workout$start[o]))
  end_time_specific_training = paste(toString(training_times_specific_workout$date[o]), toString(training_times_specific_workout$end[o]))
  sum_specific_training_duration = sum_specific_training_duration + get_duration_of_training(start_time = start_time_specific_training, end_time = end_time_specific_training)
  counter_specific_training=o
}

#print(sum_specific_training_duration)
average_specific_training_duration= sum_specific_training_duration/counter_specific_training

print(sprintf("The average training duration of a specific training of an athlete is: %s min",toString(average_specific_training_duration)))

#AVERAGE OF THE TRAINING DURATION OF A CERTAIN TRAINING OVER ALL ATHLETS













#result = left_join( dbGetQuery(conn, "SELECT * FROM athletes_workout_data") , dbGetQuery(conn, "SELECT * FROM athletes_athletes"), by = c("id"))



#print(result)


#get_duration_of_training <- function(start_time, end_time) {
#  print(difftime(start_time, end_time, units = "mins"))
#}

#dbDisconnect()
