# Exercise 1

# Asked to draw reaction diagram

# Exercise 2

# Both range() and var() are bad names for reactives - INSTEAD:

library(shiny)
df <- mtcars
ui <- fluidPage(
  selectInput("var", NULL, choices = colnames(df)),
  verbatimTextOutput("debug")
)
}
server <- function(input, output, session) {
  col_var <- reactive( df[input$var] )
  col_range <- reactive({ range(col_var(), na.rm = TRUE ) })
  output$debug <- renderPrint({ col_range() })
  shinyApp(ui = ui, server = server)

# Exercise 3
# Disable searching and ordering of datatable

library(shiny)

ui <- fluidPage(
  dataTableOutput("table")
)
server <- function(input, output, session) {
  output$table <- renderDataTable(mtcars, options = list(pageLength = 5, 
                                                         searching = FALSE,
                                                         ordering = FALSE
                                                         ))
}

shinyApp(ui, server)


# Exercise 4 - (POSITION)
ui <- fluidPage(
  titlePanel("Central limit theorem"),
  sidebarLayout( position = "right",
    sidebarPanel(
      numericInput("m", "Number of samples:", 2, min = 1, max = 100)
    ),
    mainPanel(
      plotOutput("hist")
    )
  )
)
server <- function(input, output, session) {
  output$hist <- renderPlot({
    means <- replicate(1e4, mean(runif(input$m)))
    hist(means, breaks = 20)
  }, res = 96)
}

shinyApp(ui, server)

# Exercise 5 - Themes
ui <- fluidPage(
  theme = bslib::bs_theme(bootswatch = "darkly"),
  titlePanel("Central limit theorem"),
  sidebarLayout( position = "right",
    sidebarPanel(
      numericInput("m", "Number of samples:", 2, min = 1, max = 100)
    ),
    mainPanel(
      plotOutput("hist")
    )
  )
)
server <- function(input, output, session) {
  output$hist <- renderPlot({
    means <- replicate(1e4, mean(runif(input$m)))
    hist(means, breaks = 20)
  }, res = 96)
}

shinyApp(ui, server)

# Exercise 6
# From solution
library(shiny)
ui <- fluidPage(
  fluidRow(
    column(width = 6, plotOutput("plot1")),
    column(width = 6, plotOutput("plot2"))
  )
)
server <- function(input, output, session) {
  output$plot1 <- renderPlot(plot(1:5))
  output$plot2 <- renderPlot(plot(1:5))
}
shinyApp(ui, server)

# From GPT

library(shiny)

ui <- fluidPage(
  theme = bslib::bs_theme(bootswatch = "darkly"),
  titlePanel("Central limit theorem"),
  fluidRow(
    div(
      style = "display: flex; width: 100%; height: 100vh;", # Flexbox container
      div(
        style = "flex: 1; padding: 10px;", # First histogram (50% width)
        plotOutput("hist1", width = "100%", height = "100%")
      ),
      div(
        style = "flex: 1; padding: 10px;", # Second histogram (50% width)
        plotOutput("hist2", width = "100%", height = "100%")
      )
    )
  )
)

server <- function(input, output, session) {
  output$hist1 <- renderPlot({
    hist(rnorm(1000), breaks = 20)
  }, res = 96) 
  
  output$hist2 <- renderPlot({
    hist(rnorm(1000), breaks = 20)
  }, res = 96)
}

shinyApp(ui, server)


# Exercise 7

ui <- fluidPage(
  titlePanel("Central limit theorem"),
  PlotOutput("hist")
                 )
  

server <- function(input, output, session) {
  output$hist <- renderPlot({
    means <- replicate(1e4, mean(runif(input$m)))
    hist(means, breaks = 20)
  }, res = 96)
}

shinyApp(ui, server)
