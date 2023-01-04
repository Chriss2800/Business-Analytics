## app.R ##

library(shinydashboard)
#########################################
ui <- dashboardPage(
  dashboardHeader(title = "Sporta",
                  dropdownMenu(type = "notification",
                               badgeStatus = NULL,
                               icon = icon("house"),
                               headerText = " ",
                               notificationItem("Home", icon = icon("house"), status = "primary",
                                                href = 'http://127.0.0.1:8000/'),                             
                               notificationItem("Create Athlete", icon = icon("person"), status = "primary",
                                                href = 'http://127.0.0.1:8000/create_athlete/'),
                               notificationItem("Create Training", icon = icon("dumbbell"), status = "primary",
                                                href = 'http://127.0.0.1:8000/create_course/'),
                               notificationItem("Create Workout", icon = icon("pen-to-square"), status = "primary",
                                                href = 'http://127.0.0.1:8000/create_training_data/'),
                               notificationItem("View Workout", icon = icon("list"), status = "primary",
                                                href = 'http://127.0.0.1:8000/workout_list')
                               ),
                  dropdownMenu(type = "notification",
                               badgeStatus = NULL,
                               icon = icon("share-nodes"),
                               headerText = " ",
                               notificationItem("Whatsapp", icon = icon("whatsapp"), status = "primary",
                                                href = "https://www.whatsapp.com"),                             
                               notificationItem("Twitter", icon = icon("twitter"), status = "primary",
                                                href = "https://www.twitter.com"),
                               notificationItem("Instagram", icon = icon("instagram"), status = "primary",
                                                href = "https://www.instagram.com"),
                               notificationItem("Facebook", icon = icon("facebook"), status = "primary",
                                                href = "https://www.facebook.com"),
                               notificationItem("Telegram", icon = icon("telegram"), status = "primary",
                                                href = "https://telegram.org")
                               )
                  ),
  dashboardSidebar(
    sidebarMenu(
      id = "sidebar",
      menuItem("Athlete", tabName = "athlete", icon = icon("person-running")),
      div( 
           conditionalPanel("input.sidebar === 'athlete'",
                            uiOutput("ui_outputPerson"),
                            
                            
                            
                            dateInput(
                              "date",
                              "Workout Date",
                              format = "dd-mm-yyyy",
                              startview = "month",
                              weekstart = 1,
                              language = "en",
                              ),
                            
                            ## reset side bar selection
                            actionButton('reset',
                                         'Reset',
                                         icon = icon('refresh'),
                                         width = 200),
                            # submit side bar selection
                            actionButton('submit',
                                         'Submit',
                                         icon = icon('refresh'),
                                         width = 200)
                            
           )),
      menuItem("Overview", tabName = "overview", icon = icon("chart-pie"))
    )  
  ),
  dashboardBody()
)
#########################################
library(dplyr)
library(dbplyr)
library(RSQLite)
library(ggplot2)
server <- function(input, output) {
  
  conn <- DBI::dbConnect(RSQLite::SQLite(), "db.sqlite3") #Definition der COnnection von der SQLitedatei "db.sqlite3" mit der Variable "verbindung
  
  # Write the dataset into a table 
  dbListTables(conn)
  
  # get query to all tables
  athletes_workout = dbGetQuery(conn, "SELECT * FROM athletes_workout")
  athletes_athletes = dbGetQuery(conn, "SELECT * FROM athletes_athletes")
  athletes_workout_data = dbGetQuery(conn, "SELECT * FROM athletes_workout_data")  
  
  #Holt reaktive alle Athleten Daten
  sqlOutputPerson<- reactive({
   b<- c("",dbGetQuery(conn, "SELECT DISTINCT ID FROM athletes_athletes"))      #Erster Wert soll leer sein daher wurde "nichts" in der Liste vor den Werten gesetzt
    
    }) 
  #Output der sich möglich ändernden Athleten Namen
  output$ui_outputPerson <- renderUI({
    selectizeInput("select_athlete",
                   "Select or search for one or multiple athletes", 
                   choices =  sqlOutputPerson(), 
                   selected = NULL,
                   width = 200,
                   multiple = F)  
      })
 
  
 
  

  
  
  
}
#########################################
shinyApp(ui, server)