shinyUI(fluidPage(
  theme = shinytheme("spacelab"),
  tags$head(tags$link(rel="shortcut icon", href="favicon.ico")),
  #  titlePanel("Fågeltrender - Totaler"),
  sidebarLayout(
    sidebarPanel(
      
      img(src = "logo.png", width = 250),
      hr(),
      selectizeInput("name", label = "Urval av fågelarter:",
       choices = unique(birdtotals$Arthela),
       multiple = TRUE,
       options = list(maxItems = 20, placeholder = "Välj namn")#,
      ),
      
      sliderInput("range", "Intervall för årlig förändring:",
        round = TRUE, post = "%",
        min = min(birdtotals$YPctChg, na.rm = TRUE), 
        max = max(birdtotals$YPctChg, na.rm = TRUE), 
        value = c(
          min(birdtotals$YPctChg, na.rm = TRUE), 
          max(birdtotals$YPctChg, na.rm = TRUE)
        )
      ),
      
      radioButtons("series", label = "Välj rutt:",
        choices = c("Standard", "Sommar", "Vinter", "Natt"), #unique(birdtotals$Series),
        selected = c("Standard")
      ),
      
      checkboxGroupInput("significance", label = "Välj signifikans:", 
        inline = TRUE,
        choices = c("***", "**", "*")
      )      
  
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Diagram", 
          plotlyOutput("totalsPlot", height = "100%")
        ),
        tabPanel("Tabell", 
          helpText("Nuvarande urval:"),
          br(), 
          DT::dataTableOutput("table")
        ),
        tabPanel("Källa", 
          helpText("Ladda ned nuvarande data i CSV:"),
          fluidRow(p(class = "text-center", 
            downloadButton("dl", label = "Hämta all data"))
          )
        )      
      )    
    )
  )
))
