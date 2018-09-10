# package
library(shiny)
library(DT)

# source
source('TPEX_Crawler.R', encoding = 'utf-8')

# Define UI for application
ui <- fluidPage(
  
  titlePanel('櫃買中心指數資料抓取'),
  
  sidebarLayout(
    sidebarPanel(
      h3('選取資料範圍'),
      
      selectInput('Index',
                  '選取指數名稱:',
                  c('櫃買指數'      = 'reward',
                    '富櫃50指數'    = 'gretai50',
                    '高殖利率指數'  = 'gthd')
      ),
      
      actionButton("goButton", "Go!")
      
      
    ),
    
    mainPanel(
      
      h3('資料內容'),
      DTOutput('selected_index')
    )
  )
  
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  randomVals <- eventReactive(input$goButton, {
    test <- tpex_crawler(input$Index)
  })
  
  
  output$selected_index <- renderDT(
    randomVals(), 
    server = FALSE,
    extensions = 'Buttons', 
    options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
    )
  )
  
}

# Run the application 
shinyApp(ui = ui, server = server)

