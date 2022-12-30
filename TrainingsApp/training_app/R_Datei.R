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


#all workouts of a specific athlete
name = "Daniel"
colums_for_all_workouts_specific_athlete = full_dataset[,c("first_name","last_name", "description","start","end","date")]
all_workouts_specific_athlete = colums_for_all_workouts_specific_athlete[colums_for_all_workouts_specific_athlete$first_name == name,]
print(all_workouts_specific_athlete)

#average over training duration of a certain athlete over all trainings


#result = left_join( dbGetQuery(conn, "SELECT * FROM athletes_workout_data") , dbGetQuery(conn, "SELECT * FROM athletes_athletes"), by = c("id"))



#print(result)


#get_duration_of_training <- function(start_time, end_time) {
#  print(difftime(start_time, end_time, units = "mins"))
#}


