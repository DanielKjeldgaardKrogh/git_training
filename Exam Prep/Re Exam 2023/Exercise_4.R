
library(shiny)
library(thematic)
library(ggplot2)
library(tibble)
library(dplyr)

year <- txhousing[["year"]]
month <- txhousing[["month"]]

Date <- as.Date(paste(year, "-", month, "-01", sep=""))
data <- tibble(txhousing, Date = Date)

txhousing[["city"]]

ui <- fluidPage(
  titlePanel("Hoising Sales in TX"),
  sidebarLayout(
    sidebarPanel(
      selectInput("Measure", "Select Measure", choices = c("sales", "listings"), selected = "sales"),
      selectInput("City", "Select City", choices = c(unique(txhousing[["city"]]))),
      sliderInput("slider", paste0("Observation Range: (sales)" ), min = 6, 
                                                          max = 8945,
                                                          value = c(6, 8945))
    ),
    mainPanel(
      plotOutput("plot"),
      verbatimTextOutput("desc")
    )
  )
)


server <- function(input, output, session) {
  
  filtered_data <- reactive({
    req(input$Measure, input$City, input$slider)
    filter(data,
           city == input$City,
           get(input$Measure) >= input$slider[1],  
           get(input$Measure) <= input$slider[2])
    # Alternatively:
    # txhousing[[input$Measure]] >= input$slider[1],  
    # txhousing[[input$Measure]] <= input$slider[2])
  })
    
    output$desc <- renderPrint({
      req(filtered_data())
      all_data <- data[[input$Measure]]
      data_measure <- filtered_data()[[input$Measure]]
      stats <- c(
        mean_m = mean(data_measure),
        median_m = median(data_measure),
        std_m = sd(data_measure),
        min_m = min(data_measure),
        max_m = max(data_measure),
        mean = mean(all_data, na.rm = TRUE),
        median = median(all_data, na.rm = TRUE),
        std = sd(all_data, na.rm = TRUE),
        min = min(all_data, na.rm = TRUE),
        max = max(all_data, na.rm = TRUE)
        
      )
      
      cat(
      "Descriptive Statistics:\n",
      "mean: ", round(stats["mean_m"], 2), "\n",
      "median: ", round(stats["median_m"], 2), "\n",
      "std: ", round(stats["std_m"], 2), "\n",
      "min: ", round(stats["min_m"], 2), "\n",
      "max: ", round(stats["max_m"], 2), "\n",
      "\n",
      "General Descriptive Statistics (All Data):\n",
      "mean: ", round(stats["mean"], 2), "\n",
      "median: ", round(stats["median"], 2), "\n",
      "std: ", round(stats["std"], 2), "\n",
      "min: ", round(stats["min"], 2), "\n",
      "max: ", round(stats["max"], 2), "\n"
      )
    })
  
    output$plot <- renderPlot({
      thematic::thematic_shiny()
            ggplot(filtered_data(), aes(Date, .data[[input$Measure]])) + geom_smooth() + geom_point()
    }, res = 96) 
    
    observe({
      updateSliderInput(session, "slider", 
                        label = paste0("Observation Range: (", input$Measure, ")"),
                        min = min(txhousing[[input$Measure]], na.rm = TRUE),
                        max = max(txhousing[[input$Measure]], na.rm = TRUE),
                        value = c(min(txhousing[[input$Measure]], na.rm = TRUE), 
                                  max(txhousing[[input$Measure]], na.rm = TRUE)))
    })

}

shinyApp(ui = ui, server = server)


