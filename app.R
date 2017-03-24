library(shiny)
source("/home/imran/backup/backup/RWorkspace/RandomForest/R/MyUtils.R")
ui <- fluidPage(
  tags$head(tags$script(src="textselection.js")),
  titlePanel("Corpus Annotation Utility"),
  sidebarLayout(
    sidebarPanel(
      fileInput('fileInput', 'Select Corpus', accept = c('text', 'text','.txt')),
      actionButton("Previous", "Previous"),
      actionButton("Next", "Next"),
      actionButton("mark", "Add Markup")
    ),
    mainPanel(
     tags$h1("Sentence: "),
     htmlOutput("sentence"),
     tags$h1("Sentence marked up: "),
     htmlOutput("sentenceMarkedUp") 
    )
  )
)
server <- function(input, output) {
    sourceData <- reactive({
   corpusFile <- input$fileInput
   if(is.null(corpusFile)){
     return(readCorpus('data/news.txt'))
   }
  readCorpus(corpusFile$datapath)
  })
    
 corpus <- reactive({sourceData()}) 
 values <- reactiveValues(current = 1)
  observeEvent(input$Next,{
    if(values$current >=1 & values$current < length(corpus())){
      values$current <- values$current + 1
    }
  })
  observeEvent(input$Previous,{
    if(values$current > 1 & values$current <= length(corpus())){
      values$current <- values$current - 1
    }
  })
  output$sentence <- renderText(corpus()[values$current])
}
shinyApp(ui = ui, server = server)
