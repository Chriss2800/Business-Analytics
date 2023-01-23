## app.R ##

##############Librarys##############
#"suppressPackageStartupMessages" --> unterdrückungen dass die librarys geladen wurden und Informationen/Warnungen dass gewisse funktionen von anderen gemasked wurden
suppressPackageStartupMessages({
library(shinydashboard)
library(hms)
library(scales)
library(plyr)
library(dplyr)
library(dbplyr)
library(RSQLite)
library(ggplot2)
library(tidyverse)
library(fmsb)
library(hrbrthemes)
library(treemap)
library(shinyjs)
})

#"defaultW" unterdrückungen von Warnungen. Alle relevanten Warnungen wurden gelöst, die restlichen Probleme sorgen beispielsweise für leere Diagramme wenn keine Daten vorhanden
defaultW <- getOption("warn") 

options(warn = -1)
#########################################
#ui definierte die Funktionen bzw Gegenstände mit denen interagiert werden kann (Buttons, Inputfelder, etc.)
ui <- dashboardPage(

##############Navigationbar##############
  dashboardHeader(title = "Sporta",
                  dropdownMenu(type = "notification",
                               badgeStatus = NULL, #keine Zahlen (Anzahl der NotificationItems) hinter dem Icon                         
                               icon = icon("house"),
                               headerText = " ",
                               #items in den Dropdownmenü 
                                #status=primary sorg für das Design (bläulich) der items
                                #href Link zu den Seiten der Django Applikation
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
                               badgeStatus = NULL,#keine Zahlen (Anzahl der NotificationItems) hinter dem Icon
                               icon = icon("share-nodes"),
                               headerText = " ",
                               #items in den Dropdownmenü 
                                #status=primary -> design
                                #href Link zu socialmedia seiten (dummys)
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


##############################################Sidebar##############################################
  dashboardSidebar(
    sidebarMenu(
      id = "sidebar",

##############Athlete Sidebar##############
      menuItem("Athlete", tabName = "athlete", icon = icon("person-running")),
      div(
        
           conditionalPanel("input.sidebar === 'athlete'", #nur wenn der sidebar tab ausgewählt ist werden die folgenden inputs & outputs angezeigt
                            #uiOutput gibt im Server erstellte input dropdowns aus
                            #verbarimTextoutput gibt reactiv auf das jeweilige vorherige dropdown informationen aus
                            uiOutput("ui_outputPerson"), 
                            column(12, align = "center",verbatimTextOutput("ui_outputName")), 
                            uiOutput("ui_outputWorkout_1"), 
                            column(12, align = "center",verbatimTextOutput("ui_outputWorkoutAthlete")),

                            # reset side bar selection
                            actionButton('reset_athlete',
                                         'Reset',
                                         icon = icon('refresh'),
                                         width = 200)
                             )
           ),
##############Overview Sidebar##############
      menuItem("Overview", tabName = "overview", icon = icon("chart-pie")),
      div( 
        conditionalPanel("input.sidebar === 'overview'",#nur wenn der sidebar tab ausgewählt ist werden die folgenden inputs & outputs angezeigt
                         #uiOutput gibt im Server erstellte input dropdowns aus
                         #verbarimTextoutput gibt reactiv auf das jeweilige vorherige dropdown informationen aus
                         uiOutput("ui_outputWorkout_2"),
                         column(12, align = "center",verbatimTextOutput("ui_outputWorkoutOverview")),
                         
                         ## reset side bar selection
                         actionButton('reset_overview',
                                      'Reset',
                                      icon = icon('refresh'),
                                      width = 200)
                         )
        )  
    )  
  ),


##############################################Mainfield##############################################
  dashboardBody(
    #Nutzung der CSS im Ordner www 
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href= "head.css")
    ),
    tabItems(
##############Athlete Mainfield##############
      tabItem(tabName = "athlete", #connection zu dem jeweiligen sidebartab
              fluidRow(
                #Ausgabe von Valueboxen die im Server erstellt werden
                valueBoxOutput("ui_outputVBoxDurchschnittAthlete",width = 3),
                valueBoxOutput("ui_outputVBoxDurchschnittAthleteWorkout", width = 3),
                valueBoxOutput("ui_outputMostWorkoutAthlete", width = 3),
                valueBoxOutput("ui_outputBMI", width = 3)
                ),
              fluidRow(
                #Ausgabe von Diagrammen in Boxen (box()) die im Server erstellt werden
                box(
                  title = "Distribution of athletes performed trainings", background = "navy", solidHeader = TRUE,
                  collapsible = TRUE,
                  plotOutput("ui_outputSpiderPlot")
                    ),
                box(
                  title = "Average & Standard Deviation", background = "navy", solidHeader = TRUE,
                  collapsible = TRUE,
                  plotOutput("ui_outputBarPlot")
                    )
              ),
              fluidRow(
                box(
                  title = "Histogramm of the athletes selected workout", background = "navy", solidHeader = TRUE, width = 12,
                  collapsible = TRUE,
                  plotOutput("ui_outputHistogram")
                    )
              )
            ),

##############Overview Mainfield##############
      tabItem(tabName = "overview",
              fluidRow(
                #Ausgabe von Valueboxen die im Server erstellt  werden
                valueBoxOutput("ui_outputVBoxDurchschnittOneWorkout", width = 3),
                valueBoxOutput("ui_outputVBoxMedianOneWorkout", width = 3),
                valueBoxOutput("ui_outputVBoxSDOneWorkout", width = 3),
                valueBoxOutput("ui_outputMostWorkout", width = 3)
              ),
              fluidRow(
                #Ausgabe von Diagrammen in Boxen (box()) die im Server erstellt werden
                box(
                  title = "Distribution of all performed workouts", background = "navy", solidHeader = TRUE,
                  collapsible = TRUE,
                  plotOutput("ui_OutputTreeMap")
                  ),
                box(
                  title = "Histogramm of all performed selected workout", background = "navy", solidHeader = TRUE,
                  collapsible = TRUE,
                  plotOutput("ui_OutputScatterPlot")
                  )
                ),
              fluidRow(
                box(
                  title= "Average training duration of all athletes and each athlete specific", background= "navy", solidHeader = TRUE, width = 12,
                  collapsible = TRUE,
                  plotOutput("ui_OutputGroupedBar")
                  )
                )
              )
            )
          )
        )#Ende der UI Ein und Ausgabe



#########################################
#server arbeitet reactive auf den Input aus der UI um mit den Daten daraus und aus der SQLite Daten,ValueBoxes,Diagramme etc. an das UI zurück zugeben
server <- function(input, output, session) {

#Verbindung zu SQLite um eine vollumfassende Datentabelle zu erstellen mit der alle funktionen später arbeiten können     
full_dataset<-reactive({ 
  conn <- DBI::dbConnect(RSQLite::SQLite(),  "db.sqlite3") ##Verbindung zu Datenbank
  
  #Tabellen erstellen
  athletes_athletes <- dbGetQuery(conn, "SELECT * FROM athletes_athletes")
  athletes_workout <- dbGetQuery(conn, "SELECT * FROM athletes_workout")
  athletes_workout_data <- dbGetQuery(conn, "SELECT * FROM athletes_workout_data")
  
  #Tabellen joinen
  full_dataset <- (right_join(athletes_workout, athletes_workout_data, by = c("id" ="workout_id")))
  full_dataset <- (right_join(athletes_athletes, full_dataset, by = c("id" ="athlete_id")))
  
  #neue Spalten für eine eindeutige Bezeichnung aus id und den Namen
  full_dataset <- full_dataset %>% unite("group",id,first_name,last_name, sep = "_" , remove = FALSE)
  
  #Dauer der jeweiligen workoutdata berechnenen
  full_dataset <- full_dataset %>% mutate(dauer = difftime(paste(full_dataset$date, full_dataset$end),(paste(full_dataset$date, full_dataset$start)), units = "mins"))
  
  #Verbindung zur SQLite Datenbank beenden
  dbDisconnect(conn)
  
  #Ausgabe und konvertierung des vollen Datensatzes in einem dataframe
  data.frame(full_dataset)
  
})  


##############################################Tab1 Daten##############################################
#hier werden Daten reactive in der Regel mit Hilfe des vollen Dataets (full_dataset) in passende Formate und Ausgaben bearbeitet

##############Input Dropdown Athlete##############
#reactive Ausgabe der IDs der Sportler für das Inputdropdown in der Sidebar
  sqlOutputPerson<- reactive({
    conn <- DBI::dbConnect(RSQLite::SQLite(),  "db.sqlite3") #Verbindung zu Datenbank
    b<- c("",dbGetQuery(conn, "SELECT DISTINCT id FROM athletes_athletes"))      #Erster Wert soll leer sein daher wurde "nichts" in der Liste vor den Werten gesetzt
    dbDisconnect(conn)
    b<-b
    
  }) 
##############Input Dropdown Workout##############
#reactive Ausgabe der Sportarten  für das Inputdropdown in der Sidebar
  sqlOutputWorkout<- reactive({
    conn <- DBI::dbConnect(RSQLite::SQLite(),  "db.sqlite3") #Verbindung zu Datenbank
    b<- c("",dbGetQuery(conn, "SELECT DISTINCT designation FROM athletes_Workout")) #Erster Wert soll leer sein daher wurde "nichts" in der Liste vor den Werten gesetzt
    dbDisconnect(conn)  #Beenden der Verbindung
    b<-b
    
  })  
##############Textfeld Name Sidebar##############
#für verbatimtextoutput
  sqlSidebarName<- reactive({
    if(input$select_athlete== "" ||length(input$select_athlete)==0) {workout_data=" "} #Verhinderung von Error durch leere Daten
    else {
      #konvertierung des full_dataset zu datastring des vor- und nachnamens das zur ausgewählten ID passt(character)
      workout_data <- full_dataset() %>% filter(id== input$select_athlete) %>% select(first_name, last_name)%>% unite("name",first_name,last_name, sep = " " , remove = TRUE) %>% distinct(name)
      workout_data<-as.character(workout_data)
    }
  })
##############Textfeld Workout Sidebar##############
#verbatimtextoutput
  sqlSidebarWorkout<- reactive({
    if(input$select_workout_athlete== "" ||length(input$select_workout_athlete)==0) {workout_data=" "} #Verhinderung von Error durch leere Daten
    else {
      #konvertierung des full_dataset zu datastring der workoutdescription das zur ausgewählten designation passt(character)
      workout_data <- full_dataset() %>% filter(designation== input$select_workout_athlete) %>% select(description)%>% distinct(description)
      workout_data<-as.character(workout_data)
    }
  })  
#############Average Time per Athlete#############
  sqlAthleteAll <- reactive({
    if(input$select_athlete== "" ||length(input$select_athlete)==0) {average_training_duration="__:__:__"} #Verhinderung von Error durch leere Daten
    else{
      #berechnung des Gesamtdurchschnitt der Trainingszeit des ausgewählten Athleten(num) 
      workout_data <- full_dataset() %>% filter(id == input$select_athlete) %>% summarise(mean(dauer))
      workout_data <- as.numeric(workout_data)
      average_training_duration <-  round_hms(hms(minutes = workout_data), secs=1)#Runden auf 1sekunde
    }})
##############Average Time per Athlete and Training##############
  sqlAthleteTraining <- reactive({ 
    if(input$select_athlete == ""|| input$select_workout_athlete == ""|| length(input$select_athlete)==0 || length(input$select_workout_athlete)==0) {average_training_duration_athlete_workout="__:__:__"} #Verhinderung von Error durch leere Daten 
    else{
      #berechnung des durchschnitt der Trainingszeit des ausgewählten Athleten und der Workoutart (num)
      workout_data <- full_dataset() %>% filter(designation == input$select_workout_athlete & id == input$select_athlete)
      
    if(dim(workout_data)[1] == 0) {average_training_duration_athlete_workout="__:__:__"} #Verhinderung von Error durch leere Daten
          else{ 
      workout_data <- workout_data %>%summarise(mean(dauer))
      workout_data <- as.numeric(workout_data)
      average_training_duration_athlete_workout <-  round_hms(hms(minutes = workout_data), secs=1)#Runden auf 1sekunde
    }}})
   
##############Most used Workout##############
   sqlMostWorkoutAthlete <- reactive ({
     if(input$select_athlete== "" ||length(input$select_athlete)==0){most_workout <- "-"} #Verhinderung von Error durch leere Daten
     else {
      #Ausgabe des meistgenutzten Workouts eins Athleten(string)
      workout_data <- data.frame(full_dataset()%>%filter(id == input$select_athlete)%>%group_by(designation)%>%count(designation))    
      workout_data <- workout_data%>%slice(which.max(n))
      workout_data <- workout_data$designation
        }})

##############BMI##############
  sqlBMI <- reactive({
    if(input$select_athlete == ""||length(input$select_athlete)==0) {average_training_duration_one_workout="-"} #Verhinderung von Error durch leere Daten
    else{
      #Berechnung des BMI und anschließende Gewichtsklassen zuordnung
      workout_data <- full_dataset() %>% filter (id == input$select_athlete) %>% group_by(group, height, weight, gender) %>% summarise(.groups = "keep")
      height<- as.numeric(workout_data$height)/100
      weight<- as.numeric(workout_data$weight)
      bmi <- weight/(height^2)
    
     if(workout_data$gender == "Female"){
        if (bmi < 17.5){
          return("Underweight")
        }
        else if (bmi < 24){
          return ("Normalweight")
        }
        else if (bmi < 29){
          return ("Overweight")
        }
        else if ( bmi < 34){
          return ("Grade 1 Obesity")
        }
        else if ( bmi < 36.5){
          return("Grade 2 Obesity")
        }
        else if (bmi > 39) {
          return("Grade 3 Obesity")
        }
    }
    else {if (bmi < 18.5){
      return("Underweight")
    }
      else if (bmi < 24.9){
        return ("Normalweight")
      }
      else if (bmi < 29.9){
        return ("Overweight")
      }
      else if ( bmi < 34.9){
        return ("Grade 1 Obesity")
      }
      else if ( bmi < 39.9){
        return("Grade 2 Obesity")
      }
      else if (bmi > 40) {
        return("Grade 3 Obesity")
      }
    }
  } 
})
  
##############Spider Plot (Anzahl der verschiedenen Workoutarten des Athleten)##############
  sqlSpiderPlot <- reactive ({
    if(input$select_athlete == ""||length(input$select_athlete)==0) {workout_data <- data.frame()} #Verhinderung von Error durch leere Daten
    else{
      #Dataframe für Spiderplot/radar chart, bestehend aus Anzahl jedes Workouts und der Min und Max Anzahl zur Darstellung
      workout_data <- full_dataset() %>% filter(id == input$select_athlete) %>% group_by(designation) %>% summarise(anzahl = n())
      max_zahl <- workout_data %>% summarise(maxi=max(anzahl))
      max_zahl <- round_any(as.numeric(max_zahl),10, f= ceiling)
      workout_data <- workout_data %>% add_column(.before = "anzahl", maxi=max_zahl,mini=0)
      workout_data <- data.frame(t(workout_data))
      suppressMessages(workout_data <- workout_data %>% set_names(as.character(slice(., 1))) %>% slice(-1)%>%type_convert()) #Unterdrückung von Textausgaben im Terminal
      }})  
  
##############Barplot Average und Standard Deviation##############
  sqlBarPlot <- reactive({
    if(input$select_athlete == ""||length(input$select_athlete)==0) 
      {workout_data<-data.frame(matrix(ncol=3,nrow=0, dimnames=list(NULL, c("designation", "durchschnitt", "sd"))))} #Verhinderung von Error durch leere Daten
    else{
      #Dataframe für barplot mit errorbar, durchschnittzeit und Standard Deviation pro Workoutart des ausgewählten Athleten 
      workout_data <- full_dataset() %>% filter(id == input$select_athlete) %>% group_by(designation) %>% summarise(durchschnitt = mean(dauer), sd=sd(dauer))
      workout_data$durchschnitt<-round(as.numeric(workout_data$durchschnitt),0) # durchschnitt runden und als numeric darstellen
      data.frame(workout_data)
    
  }})
#############Histogram/Scatterplot Histogramm eines Athleten und Workouts####################
  sqlHistogram <- reactive({
    if(input$select_athlete == ""|| input$select_workout_athlete == ""|| length(input$select_athlete)==0 || length(input$select_workout_athlete)==0) 
    {workout_data<-data.frame(matrix(ncol=2,nrow=0, dimnames=list(NULL, c("date", "dauer"))))} #Verhinderung von Error durch leere Daten
    else{
      #Dataframe Datum, Dauer und Workoutart aller Trainings des ausgewählten Athletens
      workout_data <- full_dataset() %>% filter(id == input$select_athlete, designation==input$select_workout_athlete)%>%select(date,dauer)
      workout_data$dauer <- as.numeric(workout_data$dauer)
      workout_data$date <- as.Date(workout_data$date)
      data.frame(workout_data)
    
     }})
  

##############################################Tab2 Daten############################################## 

##############Textfeld Workout Sidebar##############
#verbatimtextoutput
  sqlSidebarWorkoutOverview<- reactive({
    if( input$select_workout_overview == "" ||length( input$select_workout_overview)==0) {workout_data=" "} #Verhinderung von Error durch leere Daten
    else {
      #konvertierung des full_dataset zu datastring der workoutdescription das zur ausgewählten designation passt(character)
      workout_data <- full_dataset() %>% filter(designation ==  input$select_workout_overview) %>% select(description)%>% distinct(description)
      workout_data<-as.character(workout_data)
    }
  })  
#############Average Training time Specific Workout of all Athletes####################
  sqlWorkoutTime <- reactive({
    if(input$select_workout_overview == "") {average_training_duration_one_workout="__:__:__"} #Verhinderung von Error durch leere Daten
      else{
        #Ausgabe Zahl des Durchschnitts aller Trainingseinheiten aller Athleten einer Workoutart (num)
        workout_data<- full_dataset() %>% filter(designation == input$select_workout_overview) %>% summarise(durchschnitt = mean(dauer))
        
          if(dim(workout_data)[1] == 0) {average_training_duration_one_workout="__:__:__"}
        else{
        workout_data<- as.numeric(workout_data)
        average_training_duration_one_workout= round_hms(hms(minutes = workout_data), secs=1)#Runden auf 1sekunde
        }
    }})
#############Median Training time Specific Workout#############
  sqlWorkoutTimeMedian <- reactive({
    if(input$select_workout_overview == "") {median_training_duration_one_workout="__:__:__"} #Verhinderung von Error durch leere Daten
    else{
      #Ausgabe Median aller Trainingseinheiten aller Athleten einer Workoutart (num)
      workout_data<- full_dataset() %>% filter(designation == input$select_workout_overview) %>% summarise(durchschnitt = median(dauer))
      
      if(dim(workout_data)[1] == 0) {median_training_duration_one_workout="__:__:__"} 
      else{
        workout_data<- as.numeric(workout_data)
        median_training_duration_one_workout= round_hms(hms(minutes = workout_data), secs=1)#Runden auf 1sekunde
  }}})
  
#############Standard Deviation Training time Specific Workout#############
  sqlWorkoutTimeStandardDeviaton <- reactive({
    # list_certain_workout <- list()
    if(input$select_workout_overview == "") {sdworkouttime="__:__:__"}  #Verhinderung von Error durch leere Daten
    else{
      #Ausgabe Standard Deviation aller Trainingseinheiten aller Athleten einer Workoutart (num)
      workout_data<- full_dataset() %>% filter(designation == input$select_workout_overview) %>% summarise(durchschnitt = sd(dauer))
      workout_data<- as.numeric(workout_data)
      sdworkouttime<- round_hms(hms(minutes = workout_data), secs=1)#Runden auf 1sekunde
        if(is.na(sdworkouttime)){sdworkouttime="__:__:__"} else {sdworkouttime}
      }})
   
##############Most used Workout##############
   sqlMostWorkout <- reactive ({
    #Ausgabe meist durchgefühtes Training aller Athleten (string)
     workout_data <- data.frame(full_dataset()%>%group_by(designation)%>%count(designation))    
     workout_data <- workout_data%>%slice(which.max(n))
     workout_data <- workout_data$designation
   }) 
  
##############Scatter Plot Histogramm##############
  sqlOutputScatterPlot<- reactive({
    #Dataframe, date,dauer und workoutart aller Athleten 
    workout_data <- full_dataset() %>% select(group, designation, dauer, date)%>% filter(designation == input$select_workout_overview)
    workout_data$date <- as.Date(workout_data$date)
    data.frame(workout_data)   
  })
##############Workout Distribution TreeMap##############
#2Dataframes notwendig
  sqlOutputTreeMapAthlete<- reactive({
    #Dataframe Zahl der durchgeführten Trainings pro Athlet
    workout_data <- full_dataset() %>% group_by(group) %>% summarise(anzahl= n())
  })
  sqlOutputTreeMapWorkout<- reactive({
    #Dataframe Anzahl der durchgeführten Trainings pro Athlete aufgeteilt auf die Workoutart
    workout_data <- full_dataset() %>% group_by(designation, group) %>% summarise(anzahl= n())
  })
##############Average Training duration grouped Bar chart##############
  sqlOutputBar <- reactive({
    #Dataframe durchschnittszeit jedes athleten für jede Sportart
    workout_data <- full_dataset() %>% group_by(designation, group) %>% summarise(durchschnitt = mean(dauer),.groups = "keep") #.groups = keeps um nach der designation zu groupen
    workout_data_2 <- full_dataset() %>% group_by(designation) %>% summarise(durchschnitt = mean(dauer)) %>% add_column(.after="designation",group = "All") %>% bind_rows(workout_data)
    workout_data_2$durchschnitt <- round(workout_data_2$durchschnitt)
    workout_data_2$durchschnitt <- as.numeric(workout_data_2$durchschnitt)
    data.frame(workout_data_2)
  })


##############################################Tab1 Sidebar##############################################
#die Zuvor bezogenen und bearbeiteten Daten in Dropdowns einfügen und die jeweiligen Elemente (Dropdowns, Resetbutton, etc.) definieren

##############Dropdownmenu Athlete##############
  output$ui_outputPerson <- renderUI({
    selectizeInput("select_athlete",
                   "Select or search a athlete", 
                   choices =  sqlOutputPerson(), 
                   selected = NULL,
                   width = 225,
                   multiple = F)  
  })
  
##############Dropdownmenu Workout Tab1##############
  output$ui_outputWorkout_1 <- renderUI({
    selectInput("select_workout_athlete",
                   "Select or search a workout", 
                   choices =  sqlOutputWorkout(), 
                   selected = NULL,
                   width = 225,
                   multiple = F)  
  })
##############Dropdownmenu Name Tab1##############
  output$ui_outputName <- renderText({
    sqlSidebarName()
  })
##############Dropdownmenu Workout Tab1##############
  output$ui_outputWorkoutAthlete <- renderText({
    sqlSidebarWorkout()
  })
  
##############Resetbutton Funktion Tab 1##############   
  observeEvent(input$reset_athlete,{
    #bei drücken des Resetbuttons, dropdowns auf NULL setzen
    updateSelectInput(session, "select_athlete", choices=sqlOutputPerson(), selected = NULL)
    updateSelectInput(session, "select_workout_athlete", choices=sqlOutputWorkout(), selected = NULL)
    })


##############################################Tab2 Sidebar##############################################
#die Zuvor bezogenen und bearbeiteten Daten in Dropdowns einfügen und die jeweiligen Elemente (Dropdowns, Resetbutton, etc.) definieren

##############Dropdownmenu Workout Tab2##############   
  output$ui_outputWorkout_2 <- renderUI({
    selectizeInput("select_workout_overview",
                   "Select or search a workout", 
                   choices =  sqlOutputWorkout(), 
                   selected = NULL,
                   width = 225,
                   multiple = F)  
  })  
##############Dropdownmenu Workout Tab2##############
  output$ui_outputWorkoutOverview <- renderText({
    sqlSidebarWorkoutOverview()
  })  
  
##############Resetbutton Funktion Tab 2##############   
  observeEvent(input$reset_overview,{
    #bei drücken des Resetbuttons, dropdown auf NULL setzen
    updateSelectInput(session, "select_workout_overview", choices=sqlOutputWorkout(), selected = NULL)
  })


##############################################Tab1 ValueBox##############################################
#die Zuvor bezogenen und bearbeiteten Daten in Valueboxes einfügen und diese definieren

##############Athlete Average##############
  output$ui_outputVBoxDurchschnittAthlete <- renderValueBox({
    valueBox(sqlAthleteAll(), tags$p("Average training time",tags$br(), " of the athlete in general", style = "font-size: 150%;"), icon = icon("clock"), color = "light-blue",
             href = NULL)
  })   
##############Workout_Athlete Average##############
  output$ui_outputVBoxDurchschnittAthleteWorkout <- renderValueBox({
    valueBox(
      sqlAthleteTraining(), tags$p("Average training time ",tags$br(), " of the athletes specific workout", style = "font-size: 150%;"), icon = icon("clock"), color = "light-blue",
      href = NULL)
  })
##############Most done Workout##############
  output$ui_outputMostWorkoutAthlete <- renderValueBox({
    valueBox(sqlMostWorkoutAthlete(), tags$p("Most done workout ",tags$br(), " of the athlete", style = "font-size: 150%;"), icon = icon("ranking-star"), color = "light-blue",
             href = NULL)
  })
##############BMI##############
  output$ui_outputBMI <- renderValueBox({ valueBox(sqlBMI(), tags$p("BMI",tags$br(), " of the athlete ", style = "font-size: 150%;"), icon = icon("weight-scale"), color = "light-blue",
                                                   href = NULL)})


##############################################Tab2 ValueBox##############################################
#die Zuvor bezogenen und bearbeiteten Daten in Valueboxes einfügen und diese definieren

##############Workout Average##############
  output$ui_outputVBoxDurchschnittOneWorkout <- renderValueBox({
    valueBox(
      sqlWorkoutTime(), tags$p("Average training time ",tags$br(), " of a specific workout of all athletes", style = "font-size: 150%;"), icon = icon("clock"), color = "light-blue",
      href = NULL)
  })
##############Workout Median##############
  output$ui_outputVBoxMedianOneWorkout <- renderValueBox({
    valueBox(
      sqlWorkoutTimeMedian(), tags$p("Median training time",tags$br(), " of a specific workout of all athletes", style = "font-size: 150%;"), icon = icon("clock"), color = "light-blue", 
      href = NULL)
  })
  
##############Workout Standard Deviation##############
  output$ui_outputVBoxSDOneWorkout <- renderValueBox({
    valueBox(
      sqlWorkoutTimeStandardDeviaton(), tags$p("Standard Deviation of",tags$br(), " a specific workout of all athletes", style = "font-size: 150%;"), icon = icon("calculator"), color = "light-blue",
      href = NULL)
  }) 
##############Most Workout##############
  output$ui_outputMostWorkout <- renderValueBox({
    valueBox(sqlMostWorkout(), tags$p("Most completed",tags$br(), "workout of",tags$br(), "all athletes", style = "font-size: 150%;"), icon = icon("ranking-star"), color = "light-blue", 
             href = NULL)
  })


##############################################Tab1 Plots##############################################
#die Zuvor bezogenen und bearbeiteten Daten in Plots einfügen und diese definieren

##############Workout Distribution Spider Plot##############
  output$ui_outputSpiderPlot <- renderPlot({
    if(length(sqlSpiderPlot())>=3){
        radarchart(sqlSpiderPlot(), axistype = 1,
                pcol=rgb(0.2,0.5,0.5,0.9) , pfcol=rgb(0.2,0.5,0.5,0.5) , plwd=4 ,
                cglcol="grey", cglty=1, axislabcol = "black", caxislabels=seq(0,20,5), cglwd=0.8,
                vlcex=0.9)
    }
  })
##############Average und SD BarPlot##############
  output$ui_outputBarPlot <- renderPlot({
    ggplot(data=sqlBarPlot(), aes(x=designation, y=durchschnitt)) +
      geom_bar(stat="identity", color="navy", fill="white")+
      geom_text(aes(label=durchschnitt),y=-0.01*max(sqlBarPlot()$durchschnitt), hjust=1, color="black", size=5)+
      geom_errorbar(aes(ymin=durchschnitt-sd, ymax=durchschnitt+sd), width=.2,
                    position=position_dodge(.9))+
      ylab("average (minutes)")+
      coord_flip()
  })
##############Histogram of athlete&selectec workout##############
  output$ui_outputHistogram <- renderPlot({
    ggplot(sqlHistogram(), aes(x=date, y=dauer)) +
      geom_line( color="#69b3a2") +
      geom_point(shape=21, color="black", fill="#69b3a2", size=4.5) +
      theme_ipsum()+
      ylim(0,NA)+
      ylab("duration (min)")+
      xlab("")
  })
    
  
##############################################Tab2 Plots##############################################
#die Zuvor bezogenen und bearbeiteten Daten in Plots einfügen und diese definieren

##############Histogram alle Athleten##############
    output$ui_OutputScatterPlot <- renderPlot({
    ggplot(sqlOutputScatterPlot(), aes(x=date, y=dauer, color= group )) + 
      geom_point(size=6) +
      ylim(0, NA) +
      ylab("duration (min)")+
      theme_ipsum()
  })
  
##############Treemap Verteilung Athlete Workout##############
  output$ui_OutputTreeMap <- renderPlot({
    suppressMessages(
    treemap(sqlOutputTreeMapWorkout(),
            index=c("designation", "group"),
            vSize="anzahl",
            type="index",
            palette = "Dark2", # RColorBrewer::display.brewer.all() für Farbpalettenwahl
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
  )})

##############Grouped BarPlot Average all Athlete##############
  output$ui_OutputGroupedBar <- renderPlot({
    ggplot(sqlOutputBar(), aes(fill=designation, y=durchschnitt, x=group, label=durchschnitt)) + 
      geom_bar(position="dodge", stat="identity")+
      geom_text(position=position_dodge(width = 0.9), size = 5)+
      ylab("average (min)")+
      xlab("person")
      
  })
  
  


}



#########################################
shinyApp(ui, server)
#########################################
