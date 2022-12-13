library(dplyr)
library(dbplyr)
library(RSQLite)


file.exists("db.sqlite3") #zum testen ob die File überhaupt vorhanden ist. Kann später raus!
verbindung <- DBI::dbConnect(RSQLite::SQLite(), "db.sqlite3") #Definition der COnnection von der SQLitedatei "db.sqlite3" mit der Variable "verbindung"
athleten_tabelle <- tbl(verbindung, "athletes_athletes") #Aus der Verbindung mit "db.sqlite3" wird die Tabelle "athletes_athletes" in die variable "athleten_tabele" gespeichert
head(athleten_tabelle, n = 10) # Zeigt die ersten 10 Einträge der "athleten_tabelle" Tabelle an. Dient zu Veranschauung, kann später raus.