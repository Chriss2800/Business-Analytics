library(dplyr)
library(dbplyr)
library(RSQLite)


file.exists("db.sqlite3") #zum testen ob die File überhaupt vorhanden ist. Kann später raus!
verbindung <- DBI::dbConnect(RSQLite::SQLite(), "db.sqlite3") #Definition der COnnection von der SQLitedatei "db.sqlite3" mit der Variable "verbindung"
athleten_tabelle <- tbl(verbindung, "athletes_athletes") #Aus der Verbindung mit "db.sqlite3" wird die Tabelle "athletes_athletes" in die variable "athleten_tabele" gespeichert
workoutdata<- tbl(verbindung,"athletes_workout_data") #Workout data aus der SQLite extrahieren
df_workout_data<- data.frame(workoutdata) # Convert dataframe to list using data.frame()
df <- data.frame(athleten_tabelle) # Convert dataframe to list using data.frame()

