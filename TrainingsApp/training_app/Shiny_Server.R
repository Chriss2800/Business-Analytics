library(shiny)
library(shinydashboard)
library(plotly)
library(shinydashboardPlus)
library(shinyWidgets)
dashboardPage(
  dashboardHeader(),
  dashboardSidebar(),
  dashboardBody()
)

ui <- dashboardPage(
      dashboardHeader(title = "Result - Graphics",
                  leftUi = tagList(
                    actionButton(inputId = "home", label = "Home", status = "primary" , onclick ="location.href='http://127.0.0.1:8000/';",class="btn btn-primary btn btn-block"),
                    actionButton(inputId = "athlet", label = "Create Athlete", status = "primary" , onclick ="location.href='http://127.0.0.1:8000/create_athlete/';",class="btn btn-primary btn btn-block"),
                    actionButton(inputId = "training", label = "Create Training", status = "primary" , onclick ="location.href='http://127.0.0.1:8000/create_course/';",class="btn btn-primary btn btn-block"),
                    dropdownButton(
                      inputId = "mydropdown",
                      label = "Training Data",
                      status = "primary",
                      circle = FALSE,
                      actionButton(inputId = "c_workout", label = "Create Workout", onclick ="location.href='http://127.0.0.1:8000/create_training_data/';", class="btn btn-primary btn btn-block"),
                      actionButton(inputId = "v_workout", label = "View Workout", onclick ="location.href='http://127.0.0.1:8000/workout_list';", class="btn btn-primary btn btn-block"),
                      actionButton(inputId = "graphic", label = "Graphics", onclick ="location.href='http://127.0.0.1:8000/workout_list';", class="btn btn-primary btn btn-block")
                                          ),
                                                       )
  ),
                             
                  
  dashboardSidebar(
    #Welchen Content es geben soll
    sidebarMenu(
      menuItem("Athlet", tabName = "Athlet", icon = icon("person-running")),
      menuItem("Übersicht", tabName = "Übersicht", icon = icon("chart-pie"))
  ),
  uiOutput("out1")
  ),
  dashboardBody(
      #Inhalt der jeweiligen Seiten in den tewiligen Tabs unterteilt
    tabItems(
    tabItem(tabName = "Athlet",
            fluidRow(
              #Erstes Diagramm
              box(
                title = "erstes Diagramm",
                status = "info",                                                                 #ändert die Farbe der Box
                solidHeader = TRUE,                                                              #Immer sichtbare überschrift
                collapsible = TRUE,                                                               
                fig <- plot_ly(midwest, x = ~percollege, color = ~state, type = "box"))
            )
        ),
    tabItem(tabName = "Übersicht",                                                               #zweites Tab
            h2("Gesamtübersicht"),
            fluidRow(
              
            )
        )
      )
    )
)
server <- function(input, output) { }
shinyApp(ui, server)