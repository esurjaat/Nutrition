#' intake_log UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_intake_log_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' intake_log Server Functions
#'
#' @noRd 
mod_intake_log_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_intake_log_ui("intake_log_ui_1")
    
## To be copied in the server
# mod_intake_log_server("intake_log_ui_1")
