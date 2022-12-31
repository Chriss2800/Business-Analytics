library(shiny)
library(shinydashboard)
library(plotly)
dashboardPage(
  dashboardHeader(),
  dashboardSidebar(),
  dashboardBody()
)

ui <- dashboardPage(
  dashboardHeader(title = "Dashboard Athleten-Leistungen"),
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