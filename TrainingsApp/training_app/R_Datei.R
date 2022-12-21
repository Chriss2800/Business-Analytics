library(dplyr)
library(dbplyr)
library(RSQLite)


file.exists("db.sqlite3") #zum testen ob die File überhaupt vorhanden ist. Kann später raus!
verbindung <- DBI::dbConnect(RSQLite::SQLite(), "db.sqlite3") #Definition der COnnection von der SQLitedatei "db.sqlite3" mit der Variable "verbindung"

athleten_tabelle <- tbl(verbindung, "athletes_athletes") #Aus der Verbindung mit "db.sqlite3" wird die Tabelle "athletes_athletes" in die variable "athleten_tabele" gespeichert
workoutdata<- tbl(verbindung,"athletes_workout_data") #Workout data aus der SQLite extrahieren
workoutdescription<- tbl(verbindung,"athletes_workout") #Workouts aus der SQLite extrahieren

df_workout_data<- data.frame(workoutdata) # Convert dataframe to list using data.frame()
df_athletes_table<- data.frame(athleten_tabelle) # Convert dataframe to list using data.frame()
df_workout_description<- data.frame(workoutdescription) # Convert dataframe to list using data.frame()

head(athleten_tabelle, n = 10) # Zeigt die ersten 10 Einträge der "athleten_tabelle" Tabelle an. Dient zu Veranschauung, kann später raus.
=======
athlethes_counts<- df_athletes_table %>% #creating a output variable called athlethes_counts
  group_by(id) %>% #group die id column to count the id
  summarize(count=n()) #summarize to creat a count column with every id
collect() #bring back the data 
athlethes_counts #get back a athletes_count object
