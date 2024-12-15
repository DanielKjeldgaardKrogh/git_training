
library(shiny)
library(ggplot2)
library(dplyr)
library(tibble)

# Create a proper date column for the dataset
dataset <- airquality %>%
  mutate(
    month = as.Date(paste(1973, Month, Day, sep = "-"), "%Y-%m-%d")
  )

# UI
ui <- fluidPage(
  titlePanel("Analyzing Air Quality"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        "measure",
        "Select Air Quality Measure for analysis",
        choices = names(airquality)[1:4]
      )
    ),
    mainPanel(
      plotOutput("plot"),
      verbatimTextOutput("desc")
    )
  )
)

# Server
server <- function(input, output, session) {
  
  # Reactive filtered data
  filtered_data <- reactive({
    req(input$measure)
    dataset %>%
      select(month, all_of(input$measure))
  })
  
  # Render Plot
  output$plot <- renderPlot({
    data <- filtered_data()
    
    ggplot(data, aes(x = month, y = .data[[input$measure]])) +
      geom_line(color = "blue") +
      geom_point() +
      # Highlight min and max points
      geom_point(
        data = data %>%
          filter(.data[[input$measure]] == max(.data[[input$measure]], na.rm = TRUE) |
                   .data[[input$measure]] == min(.data[[input$measure]], na.rm = TRUE)),
        aes(x = month, y = .data[[input$measure]]),
        color = c("red", "green"),
        size = 3,
        shape = "triangle"
      ) +
      scale_x_date(date_labels = "%b") +  # Use month abbreviations on x-axis
      labs(x = "Month", y = input$measure, title = paste("Air Quality Measure:", input$measure)) +
      theme_minimal()
  })
  
  # Render Descriptive Statistics
  output$desc <- renderPrint({
    req(input$measure)
    data <- filtered_data()[[input$measure]]
    
    stats <- c(
      mean = mean(data, na.rm = TRUE),
      median = median(data, na.rm = TRUE),
      std = sd(data, na.rm = TRUE),
      min = min(data, na.rm = TRUE),
      max = max(data, na.rm = TRUE)
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

# Run the Shiny app
shinyApp(ui = ui, server = server)
