#' viz_barchart UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_viz_barchart_ui <- function(id){
  ns <- NS(id)
  tagList(
    shiny::plotOutput(ns("plot"))
  )
}
    
#' viz_barchart Server Functions
#'
#' @noRd 
mod_viz_barchart_server <- function(id, log, barchart_sidebar){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    # Plot 
    plot <- reactive({
      req(log$table())
      viz_barchart(log = log$table(),
                   type = barchart_sidebar$type(),
                   week_start = barchart_sidebar$date())
    })
    
    output$plot <- 
      renderPlot({
        plot()
      })
  
 
  })
}
    
## To be copied in the UI
# mod_viz_barchart_ui("viz_barchart_ui_1")
    
## To be copied in the server
# mod_viz_barchart_server("viz_barchart_ui_1", barchart_sidebar)
