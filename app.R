library(shiny)
source("MyUtils.R")
ui <- fluidPage(
  tags$head(tags$script(src="textselection.js")),
  titlePanel("Corpus Annotation Utility"),
  sidebarLayout(
    sidebarPanel(
      fileInput('fileInput', 'Select Corpus', accept = c('text', 'text','.txt')),
      actionButton("Previous", "Previous"),
      actionButton("Next", "Next"),
      actionButton("mark", "Add Markup"),
      downloadButton(outputId = "save",label = "Download")),
    mainPanel(
      tags$h1("Sentence: "),
      htmlOutput("sentence"))
  )
)

server <- function(input, output) {
  corpus <- reactive({
    corpusFile <- input$fileInput
    if(is.null(corpusFile)) {
      return(readCorpus('data/news.txt'))
    } else {
      return(readCorpus(corpusFile$datapath))
    }
  })
  
  values <- reactiveValues(current = 1)
  observe({
    values$corpus <- corpus()
  })
  output$sentence <- renderText(values$corpus[values$current])
  
  observeEvent(input$Next,{
    if(values$current >=1 & values$current < length(corpus())) {
      values$current <- values$current + 1
    }
  })
  observeEvent(input$Previous,{
    if(values$current > 1 & values$current <= length(corpus())) {
      values$current <- values$current - 1
    }
  })
  observeEvent(input$mark,{
    values$corpus[values$current] <- input$textresult
  })
  output$save <- downloadHandler(filename = "marked_corpus.txt",
                                 content = function(file) {
                                   
                                   writeLines(text = values$corpus,
                                              con = file,
                                              sep = "\n")
                                 })
}
shinyApp(ui = ui, server = server)