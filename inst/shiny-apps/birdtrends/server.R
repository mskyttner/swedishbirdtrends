
# runs once at app launch

#species <- unique(birdtrends$Arthela)


shinyServer(function(input, output, clientData, session) {
  
  # runs once per user visit
  #species <-  unique(birdtrends$Arthela)
  
  # TODO: http://stackoverflow.com/questions/17352086/how-can-i-update-a-shiny-fileinput-object
  
  src <- reactive({
    if (!is.null(input$upload)) {
      return (input$upload$name)
    }
#     if (!is.null(input$resetButton)) {
#       return("www.fageltaxering.lu.se")
#     }
    "www.fageltaxering.lu.se"
  })
  
  #  trends <- eventReactive(input$upload, {
  trends <- reactive({
    if (!is.null(input$src) && !input$src == "www.fageltaxering.lu.se")
      return (readr::read_csv(input$upload$datapath))
    else
      return (birdtrends)
    
#     if (!is.null(input$upload))
#     if (!is.null(input$resetButton))
#       return (birdtrends)
  })

  species <- reactive({
    t <- trends()$Arthela
    s <- sort(unique(t))
    updateSelectInput(session, "species",
      label = paste("Fåglars populationstrender, art:"),
      choices = s,
      selected = s[1]
    )
    return (s)
  })  

  trend <- reactive({
    if (is.null(input$species)) return (NULL)
    res <- turn(trends(), input$species) 
    return (res)
  })  
    
  observeEvent(input$resetButton, {
    updateTextInput(session, "src", value = "www.fageltaxering.lu.se")
  })

  observeEvent(input$upload, {
    updateTextInput(session, "src", value = input$upload$name)
  })
  
  output$species <- renderUI({
    s <- species()
    if (is.null(s)) return()    
    selectInput("species", "Fågeltrender, art:", s, s[1])
  })

  output$src <- renderUI({
    s <- src()
    if (is.null(s)) return()    
    textInput("src", "Källa:", s[1])
  })  
    
  
  output$dygraph <- renderDygraph({
    if (is.null(trend())) return()
    dy(trend() %>% select(-Year, -Arthela), input$species) %>%
      dyOptions(drawGrid = FALSE)
  })
  
  output$from <- renderText({
    if (!is.null(input$dygraph_date_window))
      strftime(input$dygraph_date_window[[1]], "%Y")      
  })
  
  output$to <- renderText({
    if (!is.null(input$dygraph_date_window))
      strftime(input$dygraph_date_window[[2]], "%Y")
  })  
  
  output$table <- DT::renderDataTable({
    t <- trend()
    if (is.null(t)) return()   
    t %>% dplyr::rename(År = Year, Art = Arthela) %>%
      select(År, Art, Vinter, Sommar, Standard, Natt) %>%
      arrange(desc(År))
  }, options = list(lengthChange = FALSE, rownames = FALSE))  
  
  output$dl <- downloadHandler("birdytrends.csv", 
    contentType = "text/csv", content = function(file) {
    #s = input$x1_rows_all
    write.csv(birdtrends, file)
  })  
  
})