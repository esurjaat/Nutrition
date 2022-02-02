#' viz_scatter_meal UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_viz_scatter_meal_ui <- function(id){
  ns <- NS(id)
  tagList(
    plotOutput(ns("plot"), click = ns("plot_click")),
    tableOutput(ns("table"))
  )
}
    
#' viz_scatter_meal Server Functions
#'
#' @noRd 
mod_viz_scatter_meal_server <- function(id, log, scatter_meal_sidebar){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    # Plot ====
    data_reactive <- reactive({
      viz_scatter_meal(log = log$table(),
                       day_start = scatter_meal_sidebar$date_range() %>% .[[1]],
                       day_end = scatter_meal_sidebar$date_range() %>% .[[2]],
                       x_var = scatter_meal_sidebar$x_var(),
                       y_var = scatter_meal_sidebar$y_var())
    })
    
    
    
    output$plot <- 
      renderPlot(expr = {
        data_reactive() %>% .$plot
      })
    
    # Text ===
    table <- reactive({
      temp <- 
        data_reactive() %>% 
        .$data
      
      nearPoints(temp, coordinfo = input$plot_click, xvar = scatter_meal_sidebar$x_var(), yvar = scatter_meal_sidebar$y_var())
    })
    
    output$table <- 
      renderTable({
        table() %>% 
          titler()
      })
  })
}
    
## To be copied in the UI
# mod_viz_scatter_meal_ui("viz_scatter_meal_ui_1")
    
## To be copied in the server
# mod_viz_scatter_meal_server("viz_scatter_meal_ui_1", log, scatter_meal_sidebar)
