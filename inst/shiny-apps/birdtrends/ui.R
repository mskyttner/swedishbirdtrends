library(shiny)
library(shinythemes)
library(dygraphs)

shinyUI(fluidPage(theme = shinytheme("spacelab"),
  
# titlePanel("Fågeltrender"),
  
  sidebarLayout(
    sidebarPanel(
      
      img(src = "logo.png", width = 250),
      hr(),
      
      uiOutput("species"),
      
      hr(),
      # checkboxInput("showgrid", 
      #   label = "Visa rutnät", 
      #   value = TRUE),

      #hr(),
      helpText("Period som visas i diagrammet"),
      div("Från: ", strong(textOutput("from", inline = TRUE)), 
          "Till: ", strong(textOutput("to", inline = TRUE))),
      br(),
      
      helpText(paste0("Klicka och dra uppåt/nedåt eller åt sidan ",
        "för att zooma in, dubbelklicka sedan för att återställa.")),
      uiOutput("src")
    ),
    mainPanel(
      tabsetPanel(
        
        tabPanel("Diagram", dygraphOutput("dygraph")), 
        
        tabPanel("Tabell", 
          helpText("Nuvarande urval:"),
          br(), DT::dataTableOutput("table")
          ),
        
        tabPanel("Källa", 
          helpText("Ladda ned nuvarande data i CSV:"),
          fluidRow(p(class = "text-center", downloadButton("dl", label = "Hämta all data"))),
          hr(),
          helpText("Ladda upp och använd egen data i samma CSV format:"),
          br(),
          fileInput("upload", label = h3("Ladda upp CSV"), 
            accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")),
          hr(),
          actionButton("resetButton", "Återställ till ursprunglig data"),
          br(),
          hr()
         )      
      )
    ))
 ))