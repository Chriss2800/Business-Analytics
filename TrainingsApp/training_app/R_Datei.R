library(dplyr)
library(dbplyr)
library(RSQLite)
library(ggplot2)


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

#Funktion um den Zeitunterschied zwischen zwei Zeiten zu berechnen
get_duration_of_training <- function(start_time, end_time) {
  return(difftime(end_time, start_time, units = "mins"))
}
#print(sum_training_duration)
average_training_duration= sum_training_duration/counter

#print the sentence 
#print(paste0("The average training duration of the athlet over all trainings is: ",toString(average_training_duration)))
print(sprintf("The average training duration of %s over all trainings is: %s min",name, toString(average_training_duration)))

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

print(sprintf("The average training duration of %s of %s is: %s mins", description, name, toString(average_specific_training_duration)))

#AVERAGE OF THE TRAINING DURATION OF A CERTAIN TRAINING OVER ALL ATHLETS

description1 = "Joggen"
certain_training_over_all_athletes = colums_for_all_workouts_specific_athlete[colums_for_all_workouts_specific_athlete$description == description1,]
#check if the dataframe gives certain_training_over_all_athletes
print(certain_training_over_all_athletes)

training_times_certain_training = select(certain_training_over_all_athletes, date, start, end)

sum_certain_training_duration = 0
counter_certain_training=0

for(u in 1:nrow(training_times_certain_training)) {       # for-loop over rows
  start_time_certain_training = paste(toString(training_times_certain_training$date[u]), toString(training_times_certain_training$start[u]))
  end_time_certain_training = paste(toString(training_times_certain_training$date[u]), toString(training_times_certain_training$end[u]))
  sum_certain_training_duration = sum_certain_training_duration + get_duration_of_training(start_time = start_time_certain_training, end_time = end_time_certain_training)
  counter_certain_training=u
}

#print(sum_certain_training_duration)
average_certain_training_duration= sum_certain_training_duration/counter_certain_training

print(sprintf("The average training duration of %s over all athletes is: %s mins", description1, toString(average_certain_training_duration)))


# MEDIAN OF THE TRAINING DURATION OF A CERTAIN TRAINING OVER ALL ATHLETES
list_certain_workout <- list()

for (a in 1:nrow(training_times_certain_training)) {       # for-loop over rows
  start_time_certain_training = paste(toString(training_times_certain_training$date[a]), toString(training_times_certain_training$start[a]))
  end_time_certain_training = paste(toString(training_times_certain_training$date[a]), toString(training_times_certain_training$end[a]))
  list_certain_workout [a] = get_duration_of_training(start_time = start_time_certain_training, end_time = end_time_certain_training)
}

#print(list_certain_workout)
print(sprintf("The median of the training duration of %s over all athletes is: %s mins", description1, median(unlist(list_certain_workout))))

#STANDARD DEVIATION OF THE TRAINING DURATION OF A CERTAIN TRAINING OVER ALL ATHLETES

print(sprintf("The standard deviation of the training duration of %s over all athletes is: %s mins", description1, sd(unlist(list_certain_workout))))

#DRAW APPROPRIATE DIAGRAMS TO VISUALIZE THE DATA USING GGPLOT
#ALL TRAINING DURATION VALUES OF A SPECIFIC TRAINING
description2 = "Joggen"
specific_training_over_all_athletes = colums_for_all_workouts_specific_athlete[colums_for_all_workouts_specific_athlete$description == description2,]
#check if the dataframe gives specific_training_over_all_athletes
print(specific_training_over_all_athletes)

training_times_specific_training = select(specific_training_over_all_athletes, date, start, end)

list_specific_training <- matrix()

for (a in 1:nrow(training_times_specific_training)) {       # for-loop over rows
  start_time_certain_training = paste(toString(training_times_specific_training$date[a]), toString(training_times_specific_training$start[a]))
  end_time_certain_training = paste(toString(training_times_specific_training$date[a]), toString(training_times_specific_training$end[a]))
  list_specific_training [a] = get_duration_of_training(start_time = start_time_certain_training, end_time = end_time_certain_training)
}

column_list_specific_training = data.frame(list_specific_training)
final_list_specific_training =cbind(specific_training_over_all_athletes,column_list_specific_training)

#Benenne Spalte list_specific_training in duration um
names(final_list_specific_training)[names(final_list_specific_training) =="list_specific_training"] <- "duration"
print(final_list_specific_training)


#ggplot
ggplot(data = final_list_specific_training, aes(y=duration)) +
  geom_bar()

#AVERAGE OF THE TRAINING DURATION OVER ALL ATHLETES (I.E. PER ATHLETE AVERAGE OF THE TRAINING DURATION OVER ALL TRAININGS)










#get_duration_of_training <- function(start_time, end_time) {
#  print(difftime(start_time, end_time, units = "mins"))
#}
#dbDisconnect()
