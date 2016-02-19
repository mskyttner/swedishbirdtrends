shinyServer(function(input, output) {
  
  df <- reactive({
    df <- birdtotals
    
    if (length(input$name) > 0)
      df <- df %>% filter(Arthela %in% input$name)
    
    if (length(input$significance) > 0)
      df <- df %>% filter(Significance %in% input$significance)
    
    df <- df %>% 
      filter(Series %in% input$series) %>%
      filter(YPctChg > input$range[1] & YPctChg < input$range[2]) %>%
      mutate(Direction = ifelse(YPctChg > 0, "Ökande", 
        ifelse(YPctChg < 0, "Minskande", "Oförändrad"))) %>%
      #mutate(YPctChg = abs(YPctChg)) %>%
      arrange(desc(YPctChg))
    return (df)
  })
  
  output$totalsPlot <- renderPlotly({
    
    df <- df()
    
    if (nrow(df) < 1) return ()
    
    cols <- RColorBrewer::brewer.pal(3, "Set1")[c(2, 1)]
    
    p <- 
      plot_ly(df, x = YPctChg, y = Arthela, 
        color = Direction, colors = cols,
        type = "bar", orientation = "h")
    
    layout(p, 
      xaxis = list(title = ""),
      yaxis = list(title = ""),
      margin = list(l = 120))    
    
  })
  
  output$table <- DT::renderDataTable({
    df()
  }, options = list(lengthChange = FALSE, rownames = FALSE))  
  
  output$dl <- downloadHandler("birdytotals.csv", 
    contentType = "text/csv", content = function(file) {
    write.csv(birdtotals, file, row.names = FALSE)
  })    
   
})
