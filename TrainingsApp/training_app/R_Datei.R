library(dplyr)
library(dbplyr)
library(RSQLite)


file.exists("db.sqlite3")
verbindung <- DBI::dbConnect(RSQLite::SQLite(), "db.sqlite3")
athleten_tabelle <- tbl(verbindung, "athletes_athletes")
head(athleten_tabelle, n = 10)