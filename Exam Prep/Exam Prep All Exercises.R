# Exercise 3 - planets
library(httr2)


req <- request("https://planets-by-api-ninjas.p.rapidapi.com/v1/planets") %>%
  req_url_query("name" = "Venus") %>%
  req_headers("x-rapidapi-key" = "e2cfc6c104msh774c99e60458f59p15c0c3jsn117070aad870",
              "x-rapidapi-host" = "planets-by-api-ninjas.p.rapidapi.com")

resp <- req %>%
  req_perform()

resp %>%
  resp_body_json()

# Exercise 4 -- html and json formats

# Part 1 - json format
req <- request("http://165.22.92.178:8080") %>%
  req_url_path("responses") %>%
  req_url_query(format = "json") %>%
  req_headers(authorization = "DM_DV_123#!")

resp <- req %>%
  req_perform()

resp %>%
  resp_body_json()

# part 2 - html format
req <- request("http://165.22.92.178:8080") %>%
  req_url_path("responses") %>%
  req_url_query(format = "html") %>%
  req_headers(authorization = "DM_DV_123#!")

resp <- req %>%
  req_perform()

resp %>%
  resp_body_html()


# Exercise 5 - regression API
n <- 70
x1 <- rnorm(n=n)
x2 <- rnorm(n=n)

y <- 2*x1 + 3*x2 + rnorm(n=n)

df <- round(data.frame(y = y, x1 = x1, x2 = x2))

req <- request("http://165.22.92.178:8080") %>%
  req_url_path("lm") %>%
  req_headers(authorization = "DM_DV_123#!") %>%
  req_body_json(as.list(df)) 


resp <- req %>%
  req_perform()

resp %>%
  resp_body_json()


# Exercise 7 - Google translate API
req <- request("https://google-translate1.p.rapidapi.com") %>%
  req_url_path("/language/translate/v2/detect") %>%
  req_body_form(q = "hej jeg hedder daniel") %>%
  req_headers("x-rapidapi-key" = "e2cfc6c104msh774c99e60458f59p15c0c3jsn117070aad870",
              "x-rapidapi-host" = "google-translate1.p.rapidapi.com")

resp <- req %>%
  req_perform()

resp %>%
  resp_body_json()

#------------------------------------------------------------------------------------------------#

# Scheduling Exercises
# The first exercises revolve around cleaning memory usage and creating the Rstudio container
# The increment_one_log and file is in the old scheduling folder for these exercises.

# Exercise 7
# I get an error when running "sudo cron start" (in terminal) and assume it is because it already runs

# Exercise 8
library(cronR)
cmd <- cron_rscript(rscript = "/home/rstudio/git_training/scheduling/Given_Files/increment_one.R")
cron_add(cmd, frequency = 'minutely', id = 'job1', description = 'Our first cronR job')
cron_ls()

# Exercise 9
cron_clear()

# Exercise 10
cmd <- cron_rscript(rscript = "/home/rstudio/git_training/scheduling/Given_Files/increment_one.R")
cron_add(cmd, frequency = "minutely", id = 'job_ex9', description = 'Exercise 9 cron job',
         days_of_week = 3)

cron_ls()

# Exercise 11
cmd <- cron_rscript(rscript = "/home/rstudio/git_training/scheduling/Given_Files/increment_one.R")
cron_add(cmd, frequency = "monthly", id = 'job_ex11', description = 'Exercise 11 cron job',
         days_of_month = 15, at = '04:00')

cron_ls()

# Exercise 12
cron_save("/home/rstudio/git_training/Exam Prep/my_BI_schedule1")
cron_clear()
cron_ls()
cron_load("my_BI_schedule")
cron_clear()

# Exercise 13
cmd <- cron_rscript("/home/rstudio/git_training/scheduling/Given_Files/increment_one.R")
cron_add(cmd, frequency = 'minutely', id = 'job_100', description = 'Exercise 13 job')
cron_add(cmd, frequency = 'hourly', id = 'job_100_hourly', description = 'Exercise 13 job 2')

# Here I have moved and renamed the "increment_one_practice.R" to see if that works in the 
# Exam prep folder

cmd <- cron_rscript("/home/rstudio/git_training/Exam Prep/increment_one_practice.R")
cron_add(cmd, frequency = 'minutely', id = 'job_100', description = 'Exercise 13 job')


#---------------------------------------------------------------------------------------------

# Exercises for Data Integration 1

# Exercise 3
library(RPostgres)
library(DBI)

source("/home/rstudio/git_training/Exam Prep/psql_queries.R")

source("/home/rstudio/git_training/credentials.R")

psql_manipulate(cred = cred_psql_docker,
                query_string = "create schema intg1;")

psql_manipulate(cred = cred_psql_docker,
                query_string = "create table intg1.students(
                student_id serial primary key,
                student_name varchar(50),
                department_code int);")

psql_manipulate(cred = cred_psql_docker,
                query_string = "             
                insert into intg1.students
                values
                (default, 'John', '1'),
                (default, 'Marie', '2'); 
                ")
                
df <- data.frame(student_id=c(3, 4), student_name=c('Martin', 'Jonas'),
                 department_code = c(3,4))

psql_append_df(cred = cred_psql_docker, 
               schema_name = "intg1",
               tab_name = "students",
               df = df)

psql_select(cred = cred_psql_docker,
            query_string = "select * from intg1.students;")


# Exercise 4-6 - Alpha Vantage point Tesla price Data

library(lubridate)
library(httr2)
library(DBI)
library(tibble)
req <- request("https://alpha-vantage.p.rapidapi.com/query") %>%
  req_url_query("datatype" = "json",
                "keywords" = "Tesla",
                "function" = "SYMBOL_SEARCH") %>%
  req_headers("x-rapidapi-key" = "e2cfc6c104msh774c99e60458f59p15c0c3jsn117070aad870",
              "x-rapidapi-host" = "alpha-vantage.p.rapidapi.com")

resp <- req %>%
  req_perform()

symbols <- resp %>%
  resp_body_json()

# Here we find the best match
symbols$bestMatches[[1]]

req <- request("https://alpha-vantage.p.rapidapi.com/query") %>%
  req_url_query("datatype" = "json",
                "output_size" = "compact",
                "interval" = "60min",
                "function" = "TIME_SERIES_INTRADAY",
                "symbol" = "TSLA") %>%
  req_headers("x-rapidapi-key" = "e2cfc6c104msh774c99e60458f59p15c0c3jsn117070aad870",
              "x-rapidapi-host" = "alpha-vantage.p.rapidapi.com")

resp <- req %>%
  req_perform()

prices <- resp %>%
  resp_body_json()

# Transform timestamp to UTC time
timestamp <- lubridate::ymd_hms(names(prices$'Time Series (60min)'), tz = "America/New_York")
timestamp <- format(timestamp, tz = "UTC")

# Prepare data.frame to hold results
df_ex46 <- tibble(timestamp = timestamp,
             open = NA, high = NA, low = NA, close = NA, volume = NA)

for (i in 1:nrow(df_ex46)) {
  df_ex46[i,-1] <- as.data.frame(prices$'Time Series (60min)'[[i]])
}

psql_manipulate(cred = cred_psql_docker,
                query_string = "drop table intg1.api_prices;")

psql_manipulate(cred = cred_psql_docker,
                query_string = "create table intg1.api_prices(
                id serial primary key,
                timestamp timestamp,
                close decimal(20,3),
                volume decimal(20,3));")

df_ex46_sql = df_ex46[,c("timestamp", "close", "volume")]

psql_append_df(cred = cred_psql_docker,
               schema_name = "intg1",
               tab_name = "api_prices",
               df = df_ex46_sql)

psql_select(cred = cred_psql_docker,
            query_string = "select * from intg1.api_prices;")


#----------------------------------------------------------------------------------------------

# Exercises from Integration 2 is in the files in the folder


#----------------------------------------------------------------------------------------------

# Shiny 1 Exercises

# Exercise 1

library(shiny)
library(tidyverse)
library(ggplot2)

ui <- fluidPage(
  textInput("name", "What's your name?"),
  textOutput("Greeting")
)

server <- function(input, output, session) {
  output$Greeting <- renderText({
    paste0("Hello ", input$name)
  })
}

shinyApp(ui=ui, server=server)

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
  sliderInput("y", label = "And y is", min = 1, max = 50, value = 30),
  "then x times y is",
  textOutput("product")
)

server <- function(input, output, session) {
  output$product <- renderText({
    input$x * input$y
  })
}


shinyApp(ui, server)

# Exercise 4
ui <- fluidPage(
  sliderInput("x", "If x is", min = 1, max = 50, value = 30),
  sliderInput("y", "and y is", min = 1, max = 50, value = 5),
  "then, (x * y) is", textOutput("product"),
  "and, (x * y) + 5 is", textOutput("product_plus5"),
  "and (x * y) + 10 is", textOutput("product_plus10")
)
server <- function(input, output, session) {
  product <- reactive({ 
  input$x * input$y
  })
  output$product <- renderText({product()})
  output$product_plus5 <- renderText({product() + 5})
  output$product_plus10 <- renderText({ product() + 10})
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
  textInput("name", "", placeholder = "your name")
)

server <- function(input, output, session) {}

shinyApp(ui = ui, server = server)

# Exercise 7

library(shiny)

ui <- fluidPage(
  sliderInput("date", "When should we deliver?", step = 1, 
              max = as.Date("2020-09-23"), min = as.Date("2020-09-16"), 
              value = as.Date("2020-09-17")
              )
)

server <- function(input, output, session) {
  
}

shinyApp(ui = ui, server = server)


# Exercise 8

library(shiny)

ui <- fluidPage(
  sliderInput("value", "", value = 0, min = 0, max = 100, step = 5, 
              animate = animationOptions(interval = 100, loop = TRUE))
  
)

server <- function(input, output, session) {
  
}

shinyApp(ui = ui, server = server)

# Exercise 9
shinyApp(
  ui = fluidPage(
    selectInput("state", "Choose a state:",
                list(`East Coast` = list("NY", "NJ", "CT"),
                     `West Coast` = list("WA", "OR", "CA"),
                     `Midwest` = list("MN", "WI", "IA"))
    ),
    textOutput("result")
  ),
  server = function(input, output) {
    output$result <- renderText({
      paste("You chose", input$state)
    })
  }
)

# Exercise 10

1. 
renderPrint(summary(mtcars))
2. 
renderText("Good morning!")
3. 
renderPrint(t.test(1:5, 2:6))
4. 
renderText(str(lm(mpg ~ wt, data = mtcars)))

# verbatimTextOutput() is for code output
# textOutput() is for plain text output

# 1 & 3: verbatimTextOutput
# 2 & 4: TextOutput


# Exercise 11

library(shiny)

ui <- fluidPage(
  plotOutput("plot", 
             width = "700px", 
             height = "300px")
)

server <- function(input, output, session) {
  output$plot <- renderPlot({
    plot(1:5)
}, res = 96)
} 

shinyApp(ui = ui, server = server)


# ------------------------------------------------------------------------------------------

# Shiny 2

# Exercise 1: Reactive Graphing

# Part 1
server1 <- function(input, output, session) {
  c <- reactive(input$a + input$b)
  e <- reactive(c() + input$d)
  output$f <- renderText(e())
}

# a+b --> c
# d+c --> e
# e --> f

# a  --> 
#        c --
# b  -->     --
#              --> e   ----> f
# d     ------->


# part 2
server2 <- function(input, output, session) {
  x <- reactive(input$x1 + input$x2 + input$x3)
  y <- reactive(input$y1 + input$y2)
  output$z <- renderText(x() / y())
}

# part 3
server3 <- function(input, output, session) {
  d <- reactive(c() ^ input$d)
  a <- reactive(input$a * 10)
  c <- reactive(b() / input$c)
  b <- reactive(a() + input$b)
}


# Exercise 2 - why will the code fail and why is var a bad name

var <- reactive(df[input$var])
range <- reactive(range(var(), na.rm = TRUE))

# The code will fail because you are naming a variable (range) same name as a function range()
# var is also a bad name for a reactive, as it might be a base name for variables.

# Solution:
# This code doesn't work because we called our reactive range , so when we call the range function 
# we're actually calling our new reactive. If we change the name of the reactive from range to 
# col_range then the code will work. Similarly, var() is not a good name for a reactive
# because it's already a function to compute the variance of x ! ?cor::var


# Exercise 3 - setting ordering and searching = FALSE in options

ui <- fluidPage(
  dataTableOutput("table")
)
server <- function(input, output, session) {
  output$table <- renderDataTable(mtcars, options = list(pageLength = 5, 
                                                         ordering = FALSE,
                                                         searching = FALSE))
}

shinyApp(ui = ui, server = server)

# Exercise 4 - setting sidebar to the right in sidebarlayout

ui <- fluidPage(
  titlePanel("Central limit theorem"),
  sidebarLayout(position = "right",
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

shinyApp(ui = ui, server = server)


# Exercise 5

library(shiny)
library(thematic)

ui <- fluidPage(
  theme = bslib::bs_theme(bootswatch = "darkly"),
  titlePanel("Central limit theorem"),
  sidebarLayout(position = "right",
                sidebarPanel(
                  numericInput("m", "Number of samples:", 2, min = 1, max = 100)
                ),
                mainPanel(
                  plotOutput("hist")
                )
  )
)
server <- function(input, output, session) {
  thematic::thematic_shiny()
  output$hist <- renderPlot({
    means <- replicate(1e4, mean(runif(input$m)))
    hist(means, breaks = 20)
  }, res = 96)
}

shinyApp(ui = ui, server = server)


# Exercise 6 - fluidPage and row (50% per plot)


library(shiny)
library(thematic)

ui <- fluidPage(
  fluidRow(
    column(6,
           plotOutput("plot")),
    column(6,
           plotOutput("plot2"))
  )
)

server <- function(input, output, session) {
  output$plot <- renderPlot(plot(1:5))
  output$plot2 <- renderPlot(plot(1:5))
}

shinyApp(ui = ui, server = server)


# Exercise 7 - click handle

tabletings <- data.frame(column_1 = 1:5, column_2 = 2:6)

library(shiny)
library(thematic)
library(ggplot2)

ui <- fluidPage(
  fluidRow(
    column(6,
           plotOutput("plot", click = "somethingclick")),
    column(6,
           plotOutput("plot2", click = "somethingclick2"))
  ),
  fluidRow(
    column(6,
           tableOutput("table")),
    column(6,
           tableOutput("table2"))
  )
)

server <- function(input, output, session) {
  output$plot <- renderPlot(ggplot(tabletings, aes(column_1, column_2)) +
                            geom_point())
  output$plot2 <- renderPlot(ggplot(tabletings, aes(column_1, column_2)) +
                             geom_point())
  output$table <- renderTable({
    req(input$somethingclick)
    tabletings
  })
  output$table2 <- renderTable({
    req(input$somethingclick2)
    tabletings
  })
}

shinyApp(ui = ui, server = server)
#NOTE: could also use: nearPoints(mtcars, input$plot_click, allRows = TRUE)








# Exercise 8 - The brush, dblclick, click and hover functions
# Might be advantageous to use fluidrow etc instead of sidebar to make the tables fit.

library(shiny)
library(thematic)
library(ggplot2)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      h4("click table"),
      tableOutput("click_table"),
      h4("dblclick table"),
      tableOutput("dblclick_table"),
      h4("hover table"),
      tableOutput("hover_table"),
      h4("brush table"),
      tableOutput("brush_table")
    ),
    mainPanel(
      plotOutput("plot", click = "click_handle", dblclick = "dblclick_handle",
                 hover = "hover_handle", brush = "brush_handle")
    )
  )
)

server <- function(input, output, session) {
  
  output$plot <- renderPlot(ggplot(mtcars, aes(wt, mpg)) +
                              geom_point())
  
  output$click_table <- renderTable({
    req(input$click_handle)
    nearPoints(mtcars, input$click_handle)
  })
  output$dblclick_table <- renderTable({
    req(input$dblclick_handle)
    nearPoints(mtcars, input$dblclick_handle)
  })
  output$hover_table <- renderTable({
    req(input$hover_handle)
    nearPoints(mtcars, input$hover_handle)
  })
    output$brush_table <- renderTable({
      req(input$brush_handle)
      brushedPoints(mtcars, input$brush_handle)
  })
}

shinyApp(ui = ui, server = server)



# SOLUTION:

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














# Exercise 9 - compute limits of distance scaling

library(shiny)
library(ggplot2)
df <- data.frame(x = rnorm(100), y = rnorm(100))
ui <- fluidPage(
  plotOutput("plot", click = "plot_click"),
  textOutput("width"),
  textOutput("height"),
  textOutput("scale")
)
server <- function(input, output, session) {
  # Save the plot's widht and height.
  width <- reactive(session$clientData[["output_plot_width"]])
  height <- reactive(session$clientData[["output_plot_height"]])
  # Print the plot's width, the plot's height, and the suggested scale limits.
  output$width <- renderText(paste0("Plot's width: ", width()))
  output$height <- renderText(paste0("Plot's height: ", height()))
  output$scale <- renderText({
    paste0("Recommended limits: (0, ", max(height(), width()), ")")
  })
  # Store the distance computed by the click event.
  dist <- reactiveVal(rep(1, nrow(df)))

# Update the dist reactive as needed.
observeEvent(input$plot_click, {
  req(input$plot_click)
  dist(nearPoints(df, input$plot_click, allRows = TRUE, addDist = TRUE)$dist_)
})
output$plot <- renderPlot({
  df$dist <- dist()
  ggplot(df, aes(x, y, size = dist)) +
    geom_point()
})
}
shinyApp(ui, server)






# Exercise 10 - ambient noise

library(ambient)
noise <- ambient::noise_worley(c(100, 100))
png("noise_plot.png")
plot(as.raster(normalise(noise)))
dev.off()



# Exercise 11

library(shiny)
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Upload CSV", accept = ".csv"), # file widget
      selectInput("variable", "Select Variable", choices = NULL) # select widget
    ),
    mainPanel(
      verbatimTextOutput("results") # t-test results
    )
  )
)
server <- function(input, output,session) {
  # get data from file
  data <- reactive({
    req(input$file)
    # as shown in the book, lets make sure the uploaded file is a csv
    ext <- tools::file_ext(input$file$name)
    validate(need(ext == "csv", "Invalid file. Please upload a .csv file"))
    dataset <- vroom::vroom(input$file$datapath, delim = ",")
    # let the user know if the data contains no numeric column
    validate(need(ncol(dplyr::select_if(dataset, is.numeric)) != 0,
                  "This dataset has no numeric columns."))
    dataset
  })
  # create the select input based on the numeric columns in the dataframe
  observeEvent(input$file, {
    req(data())
    num_cols <- dplyr::select_if(data(), is.numeric)
    updateSelectInput(session, "variable", choices = colnames(num_cols))
  })
  # print t-test results
  output$results <- renderPrint({
    if(!is.null(input$variable))
      t.test(data()[input$variable])
  })
}
shinyApp(ui, server)


# Exercise 12


