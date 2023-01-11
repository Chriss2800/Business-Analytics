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
                            uiOutput("ui_outputWorkout_1"),
                            
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
      menuItem("Overview", tabName = "overview", icon = icon("chart-pie")),
      div( 
        conditionalPanel("input.sidebar === 'overview'",
                         uiOutput("ui_outputWorkout_2")))  
    )  
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "athlete",
              h2("Hello Athlete"),
              fluidRow(
                valueBoxOutput("ui_outputVBoxDurchschnittAthlete",width = 3),
                valueBoxOutput("ui_outputVBoxDurchschnittAthleteWorkout", width = 3)
                
                ),
              
            ),
      tabItem(tabName = "overview",
              h2("Hello Overalluser"),
              fluidRow(
                valueBoxOutput("ui_outputVBoxDurchschnittOneWorkout", width = 3),
                valueBoxOutput("ui_outputVBoxMedianOneWorkout", width = 3),
                valueBoxOutput("ui_outputVBoxSDOneWorkout", width = 3)
              ),
              fluidRow(box(
                title = "Distribution of all performed trainings", background = "teal", solidHeader = TRUE,
                collapsible = TRUE,
                plotOutput("ui_OutputTreeMap")
                ),
                      box(
                        title = "Histogramm of all done specific workout", background = "teal", solidHeader = TRUE,
                        collapsible = TRUE,
                        plotOutput("ui_OutputScatterPlot")
                      )
              ),
              fluidRow(box(
                title= "Average trainingduration of all athletes and each athlete specific", background= "teal", solidHeader = TRUE,
                collapsible = TRUE,
                plotOutput("ui_OutputGroupedBar")
              ))
      )
      
          )
    
    
  )
)
#########################################
library(dplyr)
library(dbplyr)
library(RSQLite)
library(ggplot2)
library(tidyverse)
server <- function(input, output) {
 
  conn <- DBI::dbConnect(RSQLite::SQLite(), "db.sqlite3") #Definition der COnnection von der SQLitedatei "db.sqlite3" mit der Variable "verbindung
  
  get_duration_of_training <- function(start_time, end_time) {
    return(difftime(end_time, start_time, units = "mins"))
  }
  athletes_athletes = dbGetQuery(conn, "SELECT * FROM athletes_athletes")
  athletes_workout = dbGetQuery(conn, "SELECT * FROM athletes_workout")
  athletes_workout_data = dbGetQuery(conn, "SELECT * FROM athletes_workout_data")
  athleten_dictonary <- dbGetQuery(conn, "SELECT DISTINCT id, first_name, last_name FROM athletes_athletes")
  athleten_dictonary <- athleten_dictonary %>% unite("group",id,first_name,last_name, sep = " " , remove = FALSE)
  workout_dictionary <- dbGetQuery(conn, "SELECT DISTINCT id, description FROM athletes_workout")
  full_dataset = (right_join(athletes_workout, athletes_workout_data, by = c("id" ="workout_id")))
  full_dataset = (right_join(athletes_athletes, full_dataset, by = c("id" ="athlete_id")))
  full_dataset = full_dataset %>% unite("group",id,first_name,last_name, sep = "_" , remove = FALSE)
  full_dataset= full_dataset %>% mutate(dauer = difftime(paste(full_dataset$date, full_dataset$end),(paste(full_dataset$date, full_dataset$start)), units = "mins")) 
   sum_training_duration = 0
  ########Average Time per Athlete######
  sqlAthleteAll <- reactive({
    if(input$select_athlete == "") {average_training_duration="--"} else{
      
   
  # get query to workoutdata tables
    workout_data=athletes_workout_data[athletes_workout_data$athlete_id == input$select_athlete,]
    training_times_athlete = select(workout_data, date, start, end)
   
    for(i in 1:nrow( training_times_athlete)) {       # for-loop over rows
     start_time_training = paste(training_times_athlete$date[i], training_times_athlete$start[i])
     end_time_training = paste(training_times_athlete$date[i], training_times_athlete$end[i])
     sum_training_duration = sum_training_duration + difftime(end_time_training, start_time_training, units = "mins")
     counter=i
   }
    average_training_duration <- toString(sum_training_duration/counter)
  }})
  
  
##############Average Time per Athlete and Training##############
  
  sqlAthleteTraining <- reactive({ 
    if(input$select_athlete == ""|| input$select_workout_athlete == "") {average_training_duration_athlete_workout="--"} 
    else{
          workout_and_workout_data = (right_join(athletes_workout, athletes_workout_data, by = c("id" ="workout_id")))
    
          specific_workout_data=workout_and_workout_data[workout_and_workout_data$athlete_id == input$select_athlete &
                                                  workout_and_workout_data$description == input$select_workout_athlete,]
    
          training_times_athlete_workout = select(specific_workout_data, date, start, end)
    
    if(dim(specific_workout_data)[1] == 0) {average_training_duration_athlete_workout="--"} 
          else{ 
                for(i in 1:nrow(training_times_athlete_workout)) {       # for-loop over rows
                    start_time_training = paste(training_times_athlete_workout$date[i], training_times_athlete_workout$start[i])
                    end_time_training = paste(training_times_athlete_workout$date[i], training_times_athlete_workout$end[i])
                    sum_training_duration = sum_training_duration + difftime(end_time_training, start_time_training, units = "mins")
                    counter=i    }
    average_training_duration_athlete_workout <- toString(sum_training_duration/counter)
    }}})
  #############Average Training time Specific Workout ####################
  sqlWorkoutTime <- reactive({
    if(input$select_workout_overview == "") {average_training_duration_one_workout="--"} else{
      workout_and_workout_data = (right_join(athletes_workout, athletes_workout_data, by = c("id" ="workout_id")))
      certain_training_over_all_athletes = workout_and_workout_data[workout_and_workout_data$description == input$select_workout_overview,]
      
      training_times_certain_training = select(certain_training_over_all_athletes, date, start, end)
      
      if(dim(training_times_certain_training)[1] == 0) {average_training_duration_one_workout="--"} 
      else{
      
      for(i in 1:nrow(training_times_certain_training)) {       # for-loop over rows
        start_time_certain_training = paste(training_times_certain_training$date[i], training_times_certain_training$start[i])
        end_time_certain_training = paste(training_times_certain_training$date[i], training_times_certain_training$end[i])
        sum_training_duration = sum_training_duration + get_duration_of_training(start_time = start_time_certain_training, end_time = end_time_certain_training)
        counter_certain_training=i
      }
      
        average_training_duration_one_workout= sum_training_duration/counter_certain_training
      } 
    }
  })
  #############Median Training time Specific Workout ####################
  sqlWorkoutTimeMedian <- reactive({
    list_certain_workout <- list()
    if(input$select_workout_overview == "") {medianworkouttime="--"} else {
      
      workout_and_workout_data = (right_join(athletes_workout, athletes_workout_data, by = c("id" ="workout_id")))
      certain_training_over_all_athletes = workout_and_workout_data[workout_and_workout_data$description == input$select_workout_overview,]
      
      training_times_certain_training = select(certain_training_over_all_athletes, date, start, end)
      
        if(dim(training_times_certain_training)[1] == 0) {medianworkouttime="--"} else{
          for (i in 1:nrow(training_times_certain_training)) {       # for-loop over rows
            start_time_certain_training = paste(training_times_certain_training$date[i], training_times_certain_training$start[i])
            end_time_certain_training = paste(training_times_certain_training$date[i], training_times_certain_training$end[i])
            list_certain_workout [i] = get_duration_of_training(start_time = start_time_certain_training, end_time = end_time_certain_training)
              }
    medianworkouttime = median(unlist(list_certain_workout))
  }}})
  
  #############Standard Deviation Training time Specific Workout ####################
  sqlWorkoutTimeStandardDeviaton <- reactive({
    list_certain_workout <- list()
    if(input$select_workout_overview == "") {sdworkouttime="--"} else {
      
      workout_and_workout_data = (right_join(athletes_workout, athletes_workout_data, by = c("id" ="workout_id")))
      certain_training_over_all_athletes = workout_and_workout_data[workout_and_workout_data$description == input$select_workout_overview,]
      
      training_times_certain_training = select(certain_training_over_all_athletes, date, start, end)
      
      
        for (i in 1:nrow(training_times_certain_training)) {       # for-loop over rows
          start_time_certain_training = paste(training_times_certain_training$date[i], training_times_certain_training$start[i])
          end_time_certain_training = paste(training_times_certain_training$date[i], training_times_certain_training$end[i])
          list_certain_workout [i] = get_duration_of_training(start_time = start_time_certain_training, end_time = end_time_certain_training)
        }
      
        sdworkouttime = sd(unlist(list_certain_workout))
        if(is.na(sdworkouttime)){sdworkouttime="--"} else {sdworkouttime}
      }})
  
  
  ######## PLOTS########
  sqlOutputpiechar<- reactive({
  #subset_pie_char_specific_Workout = full_dataset[full_dataset$description == input$select_workout_overview,]
  subset_pie_char_specific_Workout <- full_dataset %>% filter(description == input$select_workout_overview,)
  mean_data <- subset_pie_char_specific_Workout %>% group_by(group) %>% summarise(mean = mean(dauer))
  mean_data$mean <- as.integer(mean_data$mean)
  data.frame(mean_data)
    })
   
   sqlOutputScatterPlot<- reactive({
     
     workout_data <- full_dataset %>% group_by(group,description, dauer, date)
     workout_data <- full_dataset %>% filter(description == input$select_workout_overview,)
     data.frame(workout_data)   
   })
   
   
   sqlOutputTreeMapAthlete<- reactive({
     workout_data <- full_dataset %>% group_by(group) %>% summarise(anzahl= n())
        })
   sqlOutputTreeMapWorkout<- reactive({
     workout_data <- full_dataset %>% group_by(description, group) %>% summarise(anzahl= n())
    
   })
   sqlOutputBar <- reactive({
     workout_data <- full_dataset %>% group_by(description, group) %>% summarise(durchschnitt = mean(dauer))
     workout_data_2 <- full_dataset %>% group_by(description) %>% summarise(durchschnitt = mean(dauer)) %>% add_column(.after="description",group = "Alle") %>% bind_rows(workout_data)
   })
  
 #############Input Dropdown Athleten ####################
    #Holt reaktive alle Athleten Daten
  sqlOutputPerson<- reactive({
   b<- c("",dbGetQuery(conn, "SELECT DISTINCT id FROM athletes_athletes"))      #Erster Wert soll leer sein daher wurde "nichts" in der Liste vor den Werten gesetzt
                           }) 
  #############Input Dropdown Workout ####################
  sqlOutputWorkout<- reactive({
    b<- c("",dbGetQuery(conn, "SELECT DISTINCT description FROM athletes_Workout"))
  })
 #####################Grafische Ausgaben########## 
   #Output der  Athleten IDs in der Sidebar
  output$ui_outputPerson <- renderUI({
    selectizeInput("select_athlete",
                   "Select or search for a athlete", 
                   choices =  sqlOutputPerson(), 
                   selected = NULL,
                   width = 225,
                   multiple = F)  
      })
  
  #Output der Workout Namen in der Sidebar
  output$ui_outputWorkout_1 <- renderUI({
    selectizeInput("select_workout_athlete",
                   "Select or search for a workout", 
                   choices =  sqlOutputWorkout(), 
                   selected = NULL,
                   width = 225,
                   multiple = F)  
  })
  output$ui_outputWorkout_2 <- renderUI({
    selectizeInput("select_workout_overview",
                   "Select or search for a workout", 
                   choices =  sqlOutputWorkout(), 
                   selected = NULL,
                   width = 225,
                   multiple = F)  
  })

  output$ui_outputVBoxDurchschnittAthlete <- renderValueBox({
    valueBox(
     paste(sqlAthleteAll(),"min"), tags$p("Average Training Time", style = "font-size: 150%;"), icon = icon("clock"), color = "green", width = 4,
             href = NULL)
  })
  output$ui_outputVBoxDurchschnittAthleteWorkout <- renderValueBox({
    valueBox(
      paste(sqlAthleteTraining(),"min"), tags$p("Average Training Time of a specific Workout", style = "font-size: 150%;"), icon = icon("clock"), color = "green", width = 4,
      href = NULL)
  })
  
  ########### Tab2
  output$ui_outputVBoxDurchschnittOneWorkout <- renderValueBox({
    valueBox(
      paste(sqlWorkoutTime(),"min"), tags$p("Average Training Time of a specific Workout of all Athletes", style = "font-size: 150%;"), icon = icon("clock"), color = "green", width = 4,
      href = NULL)
  })
  
  output$ui_outputVBoxMedianOneWorkout <- renderValueBox({
    valueBox(
      paste(sqlWorkoutTimeMedian(),"min"), tags$p("Median Time of a specific Workout of all Athletes", style = "font-size: 150%;"), icon = icon("clock"), color = "green", width = 4,
      href = NULL)
  })
  
  
  output$ui_outputVBoxSDOneWorkout <- renderValueBox({
    valueBox(
      paste(sqlWorkoutTimeStandardDeviaton(),"min"), tags$p("Standard Deviation of a specific Workout of all Athletes", style = "font-size: 150%;"), icon = icon("clock"), color = "green", width = 4,
      href = NULL)
  })
############## Plots Overview###############  
  output$ui_outputBoxPieChart <- renderPlot({
    
    # Barplot
    #ggplot(sqlOutputpiechar(), aes(x=group, y=mean, fill = x)) + 
     # geom_bar(stat = "identity")
    ggplot(sqlOutputpiechar(), aes(x="", y=mean, fill=group)) +
      geom_bar(stat="identity", width=1) +
      coord_polar("y", start=0)
    
  })
  
  output$ui_OutputScatterPlot <- renderPlot({

    library(hrbrthemes)

    
    # A basic scatterplot with color depending on Species
    ggplot(sqlOutputScatterPlot(), aes(x=date, y=dauer, color= group )) + 
      geom_point(size=6) +
      ylim(0, NA) +
      theme_ipsum()
  })
  

  output$ui_OutputTreeMap <- renderPlot({
    # library
    library(treemap)
    
    
   
    
    # treemap
    treemap(sqlOutputTreeMapWorkout(),
            index=c("description", "group"),
            vSize="anzahl",
            type="index",
            palette = "Set1", # RColorBrewer::display.brewer.all() für Farbpalettenwahl
            title = "",
            fontcolor.labels=c("black","white"),
            fontsize.labels=c(15,12),
            fontface.labels=c(4,3),                  # Font of labels: 1,2,3,4 for normal, bold, italic, bold-italic...
            bg.labels = 0,
            align.labels=list(
              c("center", "center"), 
              c("right", "bottom")
            ),
            border.col = "white")
         })
  
  output$ui_OutputGroupedBar <- renderPlot({
    ggplot(sqlOutputBar(), aes(fill=description, y=durchschnitt, x=group, label=durchschnitt)) + 
      geom_bar(position="dodge", stat="identity")+
      geom_text(position=position_dodge(width = 0.9), size = 3)
  })
  
  
}
#########################################
shinyApp(ui, server)