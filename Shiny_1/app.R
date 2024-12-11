
# Exercise 1
library(shiny)

ui <- fluidPage(
  textInput("name", "What's your name?"),
  textOutput("greeting")
)

server <- function(input, output, session) {
  output$greeting <- renderText({
    paste0("Hello ", input$name)
  })
}
shinyApp(ui, server)

# Exercise 2
library(shiny)
ui <- fluidPage(
  sliderInput("x", label = "If x is", min = 1, max = 50, value = 30),
  "then x times 5 is",
  textOutput("product")
)
server <- function(input, output, session) {
  output$product <- renderText({
    input$x * 5
  })
}
shinyApp(ui, server)

# Exercise 3
library(shiny)
ui <- fluidPage(
  sliderInput("x", label = "If x is", min = 1, max = 50, value = 30),
  sliderInput("y", label = "and y is", min = 1, max = 50, value = 30),
  "then, x times y is",
  textOutput("product")
)
server <- function(input, output, session) {
  output$product <- renderText({
    input$x * input$y
  })
}
shinyApp(ui, server)

# Exercise 4
library(shiny)
ui <- fluidPage(
  sliderInput("x", "If x is", min = 1, max = 50, value = 1),
  sliderInput("y", "and y is", min = 1, max = 50, value = 1),
  "then, (x * y) is", textOutput("product"),
  "and, (x * y) + 5 is", textOutput("product_plus5"),
  "and (x * y) + 10 is", textOutput("product_plus10")
)
server <- function(input, output, session) {
  
  product <- reactive(input$x * input$y)
  output$product <- renderText( product() )
  output$product_plus5 <- renderText( product() + 5 )
  output$product_plus10 <- renderText( product() + 10 )
}
shinyApp(ui, server)

# Exercise 5
library(shiny)
library(ggplot2)
datasets <- c("economics", "faithfuld", "seals")
ui <- fluidPage(
  selectInput("dataset", "Dataset", choices = datasets),
  verbatimTextOutput("summary"),
  plotOutput("plot")
)
server <- function(input, output, session) {
  dataset <- reactive({
    get(input$dataset, "package:ggplot2")
  })
  output$summary <- renderPrint({
    summary(dataset())
  })
  output$plot <- renderPlot({
    plot(dataset())
  }, res = 96)
}

shinyApp(ui, server)

# Exercise 6
library(shiny)

ui <- fluidPage(
  textInput("name", "", placeholder = "Your name")
  )
  
server <- function(input, output, session) {
}

shinyApp(ui, server)
  

# Exercise 7
library(shiny)

ui <- fluidPage(
  sliderInput("Dateslider", "When should we deliver", 
              min = as.Date("2020-09-16"), max = as.Date("2020-09-23"),
              value = as.Date("2020-09-17"), step = 1)
)

server <- function(input, output, session) {
}

shinyApp(ui, server)


# Exercise 8
library(shiny)

ui <- fluidPage(
  sliderInput("value", "", 
              min = 0, max = 100,
              value = 0, step = 5, animate = animationOptions(interval = 100, loop = TRUE, 
                                                             playButton = "PLAY", 
                                                             pauseButton = "PAUSE"))
)

server <- function(input, output, session) {
}

shinyApp(ui, server)

# Exercise 9
library(shiny)

ui <- fluidPage(
  selectInput("state", "Choose a state:",
              list(`East Coast` = list("NY", "NJ", "CT"),
                   `West Coast` = list("WA", "OR", "CA"),
                   `Midwest` = list("MN", "WI", "IA"))
              )
  )

server <- function(input, output, session) {
}

shinyApp(ui, server)


# Exercise 10
#Which of textOutput() and verbatimTextOutput() should each of the following render functions be 
#paired with?
# 1. renderPrint(summary(mtcars))
# 2. renderText("Good morning!")
# 3. renderPrint(t.test(1:5, 2:6))
# 4. renderText(str(lm(mpg ~ wt, data = mtcars)))

## QUOTE FROM CURRICULUM: 
# Output regular text with textOutput() and fixed code and console output with verbatimTextOutput()
# ( PSSST: textOutput is paired with rendertext(), while verbatim is paired with renderPrint() )
# Thus, 1,3 should be verbatimTextOutput() and 2,4 should be textOutput().

# Exercise 11

library(shiny)

ui <- fluidPage(
  plotOutput("plot", width = "700px", height = "300px")
  )

server <- function(input, output, session) {
  output$plot <- renderPlot({plot(1:5)}, 
  alt = " a scatterplot of five random numbers",
  res = 96)
}

shinyApp(ui, server)
