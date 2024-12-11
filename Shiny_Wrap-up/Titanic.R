titanic <- read.csv("~/git_training/Shiny_Wrap-up/titanic_case.csv")

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


