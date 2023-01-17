## app.R ##
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
defaultW <- getOption("warn") 

options(warn = -1)
#########################################
ui <- dashboardPage(

##############Navigationbar##############
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
##############################################Sidebar##############################################
  dashboardSidebar(
    sidebarMenu(
      id = "sidebar",

##############Athlete Sidebar##############
      menuItem("Athlete", tabName = "athlete", icon = icon("person-running")),
      div(
        
           conditionalPanel("input.sidebar === 'athlete'",
                            uiOutput("ui_outputPerson"),
                            uiOutput("ui_outputWorkout_1"),
                            column(12, align = "center",verbatimTextOutput("ui_outputName")),
                            tags$head(
                              tags$style(
                                HTML(
                                  "#Number_out {
       font-family:  'Source Sans Pro','Helvetica Neue',Helvetica,Arial,sans-serif;
       font-size: 14px;
        }"
                                )
                              )
                            ),
                          
                            
                            ## reset side bar selection
                            actionButton('reset_athlete',
                                         'Reset',
                                         icon = icon('refresh'),
                                         width = 200)
                           
                            
           )),
##############Overview Sidebar##############
      menuItem("Overview", tabName = "overview", icon = icon("chart-pie")),
      div( 
        conditionalPanel("input.sidebar === 'overview'",
                         uiOutput("ui_outputWorkout_2"),
                         
                         ## reset side bar selection
                         actionButton('reset_overview',
                                      'Reset',
                                      icon = icon('refresh'),
                                      width = 200)))  
    )  
  ),
##############################################Mainfield##############################################
  dashboardBody(
    tabItems(
##############Athlete Mainfield##############
      tabItem(tabName = "athlete",
              h2("Hello Athlete"),
              fluidRow(
                valueBoxOutput("ui_outputVBoxDurchschnittAthlete",width = 3),
                valueBoxOutput("ui_outputVBoxDurchschnittAthleteWorkout", width = 3),
                valueBoxOutput("ui_outputMostWorkoutAthlete", width = 3),
                valueBoxOutput("ui_outputBMI", width = 3)
                ),
              fluidRow(box(
                title = "Distribution of athletes performed trainings", background = "navy", solidHeader = TRUE,
                collapsible = TRUE,
                plotOutput("ui_outputSpiderPlot")
                ),
                       box(
                         title = "Average & SD", background = "navy", solidHeader = TRUE,
                         collapsible = TRUE,
                         plotOutput("ui_outputBarPlot")
                ),
                      box(
                        title = "Histogramm of the athletes workouts", background = "navy", solidHeader = TRUE, width = 12,
                        collapsible = TRUE,
                        plotOutput("ui_outputHistogram")
                      )
                  
                
                
              )
              
            ),
##############Overview Mainfield##############
      tabItem(tabName = "overview",
              h2("Hello Overalluser"),
              fluidRow(
                valueBoxOutput("ui_outputVBoxDurchschnittOneWorkout", width = 3),
                valueBoxOutput("ui_outputVBoxMedianOneWorkout", width = 3),
                valueBoxOutput("ui_outputVBoxSDOneWorkout", width = 3),
                valueBoxOutput("ui_outputMostWorkout", width = 3)
              ),
              fluidRow(box(
                title = "Distribution of all performed trainings", background = "navy", solidHeader = TRUE,
                collapsible = TRUE,
                plotOutput("ui_OutputTreeMap")
                ),
                      box(
                        title = "Histogramm of all done specific workout", background = "navy", solidHeader = TRUE,
                        collapsible = TRUE,
                        plotOutput("ui_OutputScatterPlot")
                      )
              ),
              fluidRow(box(
                title= "Average training duration of all athletes and each athlete specific", background= "navy", solidHeader = TRUE, width = 12,
                collapsible = TRUE,
                plotOutput("ui_OutputGroupedBar")
              ))
      )
      
          )
    
    
  )
)
#########################################
server <- function(input, output) {
  
full_dataset<-reactive({ 
  conn <- DBI::dbConnect(RSQLite::SQLite(),  "db.sqlite3") #Definition der COnnection von der SQLitedatei "db.sqlite3" mit der Variable "verbindung
  
  athletes_athletes <- dbGetQuery(conn, "SELECT * FROM athletes_athletes")
  athletes_workout <- dbGetQuery(conn, "SELECT * FROM athletes_workout")
  athletes_workout_data <- dbGetQuery(conn, "SELECT * FROM athletes_workout_data")
  full_dataset <- (right_join(athletes_workout, athletes_workout_data, by = c("id" ="workout_id")))
  full_dataset <- (right_join(athletes_athletes, full_dataset, by = c("id" ="athlete_id")))
  full_dataset <- full_dataset %>% unite("group",id,first_name,last_name, sep = "_" , remove = FALSE)
  full_dataset <- full_dataset %>% mutate(dauer = difftime(paste(full_dataset$date, full_dataset$end),(paste(full_dataset$date, full_dataset$start)), units = "mins"))
  dbDisconnect(conn)
  data.frame(full_dataset)
  
})  
##############################################Tab1 Daten##############################################
##############Input Dropdown Athlete##############
  sqlOutputPerson<- reactive({
    conn <- DBI::dbConnect(RSQLite::SQLite(),  "db.sqlite3") #Definition der COnnection von der SQLitedatei "db.sqlite3" mit der Variable "verbindung
    b<- c("",dbGetQuery(conn, "SELECT DISTINCT id FROM athletes_athletes"))      #Erster Wert soll leer sein daher wurde "nichts" in der Liste vor den Werten gesetzt
    dbDisconnect(conn)
    b<-b
    
  }) 
##############Input Dropdown Workout##############
  sqlOutputWorkout<- reactive({
    conn <- DBI::dbConnect(RSQLite::SQLite(),  "db.sqlite3") #Definition der COnnection von der SQLitedatei "db.sqlite3" mit der Variable "verbindung
    b<- c("",dbGetQuery(conn, "SELECT DISTINCT designation FROM athletes_Workout"))
    dbDisconnect(conn)
    b<-b
    
  })  
  
  sqlSidebarName<- reactive({
    workout_data <- full_dataset() %>% filter(id== input$select_athlete) %>% select(first_name, last_name)%>% unite("name",first_name,last_name, sep = " " , remove = TRUE) %>% distinct(name)
    workout_data<-as.character(workout_data)
  })
  
#############Average Time per Athlete#############
  sqlAthleteAll <- reactive({
    if(input$select_athlete== "" ||length(input$select_athlete)==0) {average_training_duration="__:__:__"} 
    else{
      workout_data <- full_dataset() %>% filter(id == input$select_athlete) %>% summarise(mean(dauer))
      workout_data <- as.numeric(workout_data)
      average_training_duration <-  round_hms(hms(minutes = workout_data), secs=1)
    }})
##############Average Time per Athlete and Training##############
  sqlAthleteTraining <- reactive({ 
    if(input$select_athlete == ""|| input$select_workout_athlete == ""|| length(input$select_athlete)==0 || length(input$select_workout_athlete)==0) {average_training_duration_athlete_workout="__:__:__"} 
    else{
      workout_data <- full_dataset() %>% filter(designation == input$select_workout_athlete & id == input$select_athlete)
      
    if(dim(workout_data)[1] == 0) {average_training_duration_athlete_workout="__:__:__"} 
          else{ 
            workout_data <- workout_data %>%summarise(mean(dauer))
            workout_data <- as.numeric(workout_data)
            average_training_duration_athlete_workout <-  round_hms(hms(minutes = workout_data), secs=1)
    }}})
   
##############Most used Workout##############
   sqlMostWorkoutAthlete <- reactive ({
     if(input$select_athlete== "" ||length(input$select_athlete)==0){most_workout <- "-"} 
     else {
      workout_data <- full_dataset()%>%filter(id == input$select_athlete) %>%summarise(max=max(designation))
      most_workout <- toString(workout_data)
      

        
   }})

##############BMI##############
  sqlBMI <- reactive({
    if(input$select_athlete == ""||length(input$select_athlete)==0) {average_training_duration_one_workout="-"} 
    else{
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
  
##############Spider Plot##############
  sqlSpiderPlot <- reactive ({
    if(input$select_athlete == ""||length(input$select_athlete)==0) {workout_data <- data.frame()} 
    else{
    workout_data <- full_dataset() %>% filter(id == input$select_athlete) %>% group_by(designation) %>% summarise(anzahl = n())
    max_zahl <- workout_data %>% summarise(maxi=max(anzahl))
    max_zahl <- round_any(as.numeric(max_zahl),10, f= ceiling)
    workout_data <- workout_data %>% add_column(.before = "anzahl", maxi=max_zahl,mini=0)
    workout_data <- data.frame(t(workout_data))
    suppressMessages(workout_data <- workout_data %>% set_names(as.character(slice(., 1))) %>% slice(-1)%>%type_convert())
    }})  
  
##############Barplot Average und SD##############
  sqlBarPlot <- reactive({
    if(input$select_athlete == ""||length(input$select_athlete)==0) 
      {workout_data<-data.frame(matrix(ncol=3,nrow=0, dimnames=list(NULL, c("designation", "durchschnitt", "sd"))))} 
    else{
    workout_data <- full_dataset() %>% filter(id == input$select_athlete) %>% group_by(designation) %>% summarise(durchschnitt = mean(dauer), sd=sd(dauer))
    workout_data$durchschnitt<-as.numeric(workout_data$durchschnitt)
    data.frame(workout_data)
    
  }})
#############Histogram####################
  sqlHistogram <- reactive({
    if(input$select_athlete == ""|| input$select_workout_athlete == ""|| length(input$select_athlete)==0 || length(input$select_workout_athlete)==0) 
    {workout_data<-data.frame(matrix(ncol=2,nrow=0, dimnames=list(NULL, c("date", "dauer"))))} 
    else{
    workout_data <- full_dataset() %>% filter(id == input$select_athlete, designation==input$select_workout_athlete)%>%select(date,dauer)
    workout_data$dauer <- as.numeric(workout_data$dauer)
    workout_data$date <- as.Date(workout_data$date)
    data.frame(workout_data)
    
     }})
  
##############################################Tab2 Daten##############################################   
#############Average Training time Specific Workout ####################
  sqlWorkoutTime <- reactive({
    if(input$select_workout_overview == "") {average_training_duration_one_workout="__:__:__"} 
      else{
      workout_data<- full_dataset() %>% filter(designation == input$select_workout_overview) %>% summarise(durchschnitt = mean(dauer))
      
        if(dim(workout_data)[1] == 0) {average_training_duration_one_workout="__:__:__"} 
      else{
      workout_data<- as.numeric(workout_data)
      average_training_duration_one_workout= round_hms(hms(minutes = workout_data), secs=1)
      }}})
#############Median Training time Specific Workout#############
  sqlWorkoutTimeMedian <- reactive({
    if(input$select_workout_overview == "") {median_training_duration_one_workout="__:__:__"} 
    else{
      workout_data<- full_dataset() %>% filter(designation == input$select_workout_overview) %>% summarise(durchschnitt = median(dauer))
      
      if(dim(workout_data)[1] == 0) {median_training_duration_one_workout="__:__:__"} 
      else{
        workout_data<- as.numeric(workout_data)
        median_training_duration_one_workout= round_hms(hms(minutes = workout_data), secs=1)
  }}})
  
#############Standard Deviation Training time Specific Workout#############
  sqlWorkoutTimeStandardDeviaton <- reactive({
    list_certain_workout <- list()
    if(input$select_workout_overview == "") {sdworkouttime="__:__:__"} 
    else{
      workout_data<- full_dataset() %>% filter(designation == input$select_workout_overview) %>% summarise(durchschnitt = sd(dauer))
      workout_data<- as.numeric(workout_data)
      sdworkouttime= round_hms(hms(minutes = workout_data), secs=1)
        if(is.na(sdworkouttime)){sdworkouttime="__:__:__"} else {sdworkouttime}
      }})
   
##############Most used Workout##############
   sqlMostWorkout <- reactive ({
     workout_data <- full_dataset()%>%summarise(max=max(designation))
     most_workout <- toString(workout_data)
   }) 
  
##############Scatter Plot Histogramm##############
  sqlOutputScatterPlot<- reactive({
    
    workout_data <- full_dataset() %>% select(group, designation, dauer, date)%>% filter(designation == input$select_workout_overview)
    #workout_data$dauer <- as.numeric( workout_data$dauer)
    data.frame(workout_data)   
  })
##############Workout Distribution TreeMap##############
  sqlOutputTreeMapAthlete<- reactive({
    workout_data <- full_dataset() %>% group_by(group) %>% summarise(anzahl= n())
  })
  sqlOutputTreeMapWorkout<- reactive({
    workout_data <- full_dataset() %>% group_by(designation, group) %>% summarise(anzahl= n())
  })
##############Average Training duration grouped Bar chart##############
  sqlOutputBar <- reactive({
    workout_data <- full_dataset() %>% group_by(designation, group) %>% summarise(durchschnitt = mean(dauer),.groups = "keep")
    workout_data_2 <- full_dataset() %>% group_by(designation) %>% summarise(durchschnitt = mean(dauer)) %>% add_column(.after="designation",group = "Alle") %>% bind_rows(workout_data)
    workout_data_2$durchschnitt <- round(workout_data_2$durchschnitt)
    workout_data_2$durchschnitt <- as.numeric(workout_data_2$durchschnitt)
    data.frame(workout_data_2)
  })
##############################################Tab1 Sidebar##############################################
##############Dropdownmenu Athlete##############
  output$ui_outputPerson <- renderUI({
    selectizeInput("select_athlete",
                   "Select or search for a athlete", 
                   choices =  sqlOutputPerson(), 
                   selected = NULL,
                   width = 225,
                   multiple = F)  
  })
  
##############Dropdownmenu Workout Tab1##############
  output$ui_outputWorkout_1 <- renderUI({
    selectizeInput("select_workout_athlete",
                   "Select or search for a workout", 
                   choices =  sqlOutputWorkout(), 
                   selected = NULL,
                   width = 225,
                   multiple = F)  
  })
  output$ui_outputName <- renderText({
    sqlSidebarName()
  })
  
  observeEvent(input$reset_athlete,{
    reset("sidebar")
  })
##############################################Tab2 Sidebar##############################################
##############Dropdownmenu Workout Tab2##############   
  output$ui_outputWorkout_2 <- renderUI({
    selectizeInput("select_workout_overview",
                   "Select or search for a workout", 
                   choices =  sqlOutputWorkout(), 
                   selected = NULL,
                   width = 225,
                   multiple = F)  
  })  
  
##############################################Tab1 ValueBox##############################################
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
    valueBox(sqlMostWorkout(), tags$p("Most completed workout",tags$br(), " of all athletes", style = "font-size: 150%;"), icon = icon("ranking-star"), color = "light-blue", 
             href = NULL)
  })
##############################################Tab1 Plots##############################################
##############Workout Distribution Spider Plot##############
  
   output$ui_outputSpiderPlot <- renderPlot({
  if(length(sqlSpiderPlot())>=3){
      radarchart(sqlSpiderPlot(), axistype = 2,
               pcol=rgb(0.2,0.5,0.5,0.9) , pfcol=rgb(0.2,0.5,0.5,0.5) , plwd=4 ,
               cglcol="grey", cglty=1, axislabcol = "black", caxislabels=seq(0,20,5), cglwd=0.8,
               vlcex=0.9)
  }
  })
##############Average und SD BarPlot##############
  output$ui_outputBarPlot <- renderPlot({
    ggplot(data=sqlBarPlot(), aes(x=designation, y=durchschnitt)) +
      geom_bar(stat="identity", color="blue", fill="white")+
      geom_text(aes(label=durchschnitt), hjust=1.6, color="black", size=3.5)+
      geom_errorbar(aes(ymin=durchschnitt-sd, ymax=durchschnitt+sd), width=.2,
                    position=position_dodge(.9))+
      coord_flip()
  })
##############Histogram##############
  output$ui_outputHistogram <- renderPlot({
    ggplot(sqlHistogram(), aes(x=date, y=dauer)) +
      geom_line( color="#69b3a2") +
      geom_point(shape=21, color="black", fill="#69b3a2", size=6) +
      theme_ipsum_es()+
      ylim(0,NA)+
      xlab("")
  })
  
  
  
##############################################Tab2 Plots##############################################
##############Histogram alle Athleten##############
    output$ui_OutputScatterPlot <- renderPlot({
    ggplot(sqlOutputScatterPlot(), aes(x=date, y=dauer, color= group )) + 
      geom_point(size=6) +
      ylim(0, NA) +
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
      geom_text(position=position_dodge(width = 0.9), size = 5)
      
  })
  
  


}
#########################################
shinyApp(ui, server)
#########################################
