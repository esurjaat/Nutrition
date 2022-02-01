#' viz_barchart_sidebar UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_viz_barchart_sidebar_ui <- function(id){
  ns <- NS(id)
  tagList(
    shiny::dateInput(inputId = ns("date"), label = "Week Start", value = lubridate::ymd("2022-01-31")),
    shiny::radioButtons(inputId = ns("type"), label = "Breakdown", choices = c("Total Calories", "Macronutrients"))
  )
}
    
#' viz_barchart_sidebar Server Functions
#'
#' @noRd 
mod_viz_barchart_sidebar_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    return(
      list(
        date = reactive({ input$date }),
        type = reactive({ input$type })
      )
    )
    
 
  })
}
    
## To be copied in the UI
# mod_viz_barchart_sidebar_ui("viz_barchart_sidebar_ui_1")
    
## To be copied in the server
# mod_viz_barchart_sidebar_server("viz_barchart_sidebar_ui_1")
