#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(DT)
library(rio)
library(ggplot2)
library(gpairs)

# Define UI for application that draws a histogram
ui <- dashboardPage(title = "Programmation R",
                    
              dashboardHeader(title = "Ma première application", titleWidth = 500), # titre
              
              dashboardSidebar(fileInput(inputId = "navig", 
                                         label = "Importer",
                                         placeholder = "Aucun fichier",
                                         accept = c(".txt", ".xlsx", ".csv", ".dta")
                                          ),
                               sidebarMenu(menuItem("tableau", tabName = "tbl"),
                                           menuItem("resume graphique", tabName = "rg"))),# barre lateral
              
              dashboardBody(
                     
                     tabItems(
                            tabItem(tabName = "tbl",
                            DTOutput(outputId = "tableau")
                            ),
                     
                     tabItem(
                            tabName = "rg", 
                            plotOutput(outputId = "rsg"))))# corps
)
       
# Define server logic required to draw a histogram
server <- function(input, output) {
       
       table <- reactive(import(file = input$navig$datapath))

       output$tableau <- renderDT({
              datatable(
                 data = table(), 
                 extensions = c("Buttons", "KeyTable"),
                 filter = "bottom",
                 options = list(
                            dom = "Bfrtip",
                            buttons = c("pdf", "excel", "csv", "print")))
              })
       
       output$rsg <- renderPlot({
              gpairs::gpairs(iris)
       })
       
}

# Run the application 
shinyApp(ui = ui, server = server)
