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

server <- function(input, output, session) {
  col_var <- reactive( df[input$var] )
  col_range <- reactive({ range(col_var(), na.rm = TRUE ) })
  output$debug <- renderPrint({ col_range() })
  shinyApp(ui = ui, server = server)
}
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
  plotOutput("plot", click = "plot_click"),
  tableOutput("data")
)
server <- function(input, output, session) {
  output$plot <- renderPlot({
    ggplot(mtcars, aes(wt, mpg)) + geom_point()
  }, res = 96)
  
  output$data <- renderTable({
    nearPoints(mtcars, input$plot_click, allRows = TRUE)
  })
}


shinyApp(ui, server)

# Exercise 8

# MY SOLUTION:

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel( width = 6,
    
      h4("selected points"), tableOutput("click"), br(),
      h4("brushed points"), tableOutput("brush"), br(),
      h4("hovered points"),tableOutput("hover"), br(),
      h4("dblclick points"),tableOutput("dblclick"), br(),
      textOutput("size_plot")
    ),
    mainPanel( width = 6,
    plotOutput("plot", click = "plot_click", hover = "plot_hover",
              brush = "plot_brush", dblclick = "plot_dblclick"))
))
server <- function(input, output, session) {
  output$plot <- renderPlot({
    ggplot(mtcars, aes(wt, mpg)) + geom_point()
  }, res = 96)
  
  output$click <- renderTable({
    req(input$plot_click)
    nearPoints(mtcars, input$plot_click)
    })
  output$brush <- renderTable({
    req(input$plot_brush)
    brushedPoints(mtcars, input$plot_brush)
  })
  output$hover <- renderTable({
    req(input$plot_hover)
    nearPoints(mtcars, input$plot_hover)
    
  })
  output$dblclick <- renderTable({
    req(input$plot_dblclick)
    nearPoints(mtcars, input$plot_dblclick)
  })
}


shinyApp(ui, server)

# GUIDED SOLUTION:

library(shiny)
library(ggplot2)
# Set options for rendering DataTables.
options <- list(
  autoWidth = FALSE,
  searching = FALSE,
  ordering = FALSE,
  lengthChange = FALSE,
  lengthMenu = FALSE,
  pageLength = 5, # Only show 5 rows per page.
  paging = TRUE, # Enable pagination. Must be set for pageLength to work.
  info = FALSE
)
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      width = 6,
      h4("Selected Points"), dataTableOutput("click"), br(),
      
      h4("Double Clicked Points"), dataTableOutput("dbl"), br(),
      
      h4("Hovered Points"), dataTableOutput("hover"), br(),
      
      h4("Brushed Points"), dataTableOutput("brush")
    ),
    
    mainPanel(width = 6,
              plotOutput("plot",
                         click = "plot_click",
                         dblclick = "plot_dbl",
                         hover = "plot_hover",
                         brush = "plot_brush")
    )
  )
)
server <- function(input, output, session) {
  
  output$plot <- renderPlot({
    ggplot(iris, aes(Sepal.Length, Sepal.Width)) + geom_point()
  }, res = 96)
  
  output$click <- renderDataTable(
    nearPoints(iris, input$plot_click),
    options = options)
  
  output$hover <- renderDataTable(
    nearPoints(iris, input$plot_hover),
    options = options)
  
  output$dbl <- renderDataTable(
    nearPoints(iris, input$plot_dbl),
    options = options)
  
  output$brush <- renderDataTable(
    brushedPoints(iris, input$plot_brush),
    options = options)
}
shinyApp(ui, server)


# Exercise 9:
output_size <- function(id) {
  reactive(c(
    session$clientData[[paste0("output_", id, "_width")]],
    session$clientData[[paste0("output_", id, "_height")]]
  ))
}

library(shiny)
library(ggplot2)

# Create sample data
df <- data.frame(x = rnorm(100), y = rnorm(100))

ui <- fluidPage(
  plotOutput("plot", click = "plot_click"),
  textOutput("width"),
  textOutput("height"),
  textOutput("scale")
)

server <- function(input, output, session) {
  # Reactive expressions to get plot dimensions
  width <- reactive(session$clientData[["output_plot_width"]])
  height <- reactive(session$clientData[["output_plot_height"]])
  
  # Display the plot's width and height
  output$width <- renderText({
    paste0("Plot's width: ", width())
  })
  
  output$height <- renderText({
    paste0("Plot's height: ", height())
  })
  
  # Calculate and display recommended limits
  output$scale <- renderText({
    req(width(), height()) # Ensure dimensions are available
    paste0("Recommended limits: (0, ", max(height(), width()), ")")
  })
  
  # Reactive value to store distance
  dist <- reactiveVal(rep(1, nrow(df)))
  
  # Update `dist` based on plot clicks
  observeEvent(input$plot_click, {
    req(input$plot_click)
    dist(nearPoints(df, input$plot_click, allRows = TRUE, addDist = TRUE)$dist_)
  })
  
  # Render the plot
  output$plot <- renderPlot({
    df$dist <- dist() # Add the updated distances to the dataframe
    ggplot(df, aes(x, y, size = dist)) +
      geom_point() +
      scale_size_continuous(range = c(1, 10)) + # Control point size range
      theme_minimal()
  })
}

shinyApp(ui, server)

   