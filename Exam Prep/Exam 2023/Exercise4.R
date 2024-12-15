
library(shiny)
library(ggplot2)
library(tibble)

month_df <- airquality[["Month"]]
day_df <- airquality[["Day"]]

# Create a proper date column for the dataset

month <- as.Date(paste(2000, month_df, day_df, sep = "-"), "%Y-%m-%d") 

dataset <- tibble(airquality, month = month)

ui <- fluidPage(
  titlePanel("Analyzing Air Quality"),
  sidebarLayout(
    sidebarPanel(
      selectInput("measure", "Select Air Quality Measure for analysis", 
                  choices = c(colnames(dataset)[1:4]))
    ),
    mainPanel(
      plotOutput("plot"),
      verbatimTextOutput("desc")
    )
  )
)

server <- function(input, output, session) {
  
  filtered_data <- reactive({
    req(input$measure)
    data <- dataset[[input$measure]]
  })
  
  output$plot <- renderPlot({
    ggplot(dataset, aes(month, .data[[input$measure]])) + 
      geom_point() +
      geom_point(data = dataset[which.min(dataset[[input$measure]]),], 
                 color="red", 
                 size=3,
                 shape = "triangle") +
      geom_point(data = dataset[which.max(dataset[[input$measure]]),], 
                 color="green", 
                 size=3,
                 shape = "triangle") +
      geom_line(colour = "blue") +
      theme_minimal() +
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
  })
  
  output$desc <- renderPrint({
    req(input$measure)
    
    stats <- c(
      mean = mean(filtered_data(), na.rm = TRUE),
      median = median(filtered_data(), na.rm = TRUE),
      std = sd(filtered_data(), na.rm = TRUE),
      min = min(filtered_data(), na.rm = TRUE),
      max = max(filtered_data(), na.rm = TRUE)
    )
    
    cat("Descriptive Statistics:\n",
    "mean: ", stats["mean"], "\n",
    "median: ", stats["median"], "\n",
    "std: ", stats["std"], "\n",
    "min: ", stats["min"], "\n",
    "max: ", stats["max"]
    )
  })
}

shinyApp(ui = ui, server = server)

