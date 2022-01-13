#' intake_summary UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_intake_summary_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' intake_summary Server Functions
#'
#' @noRd 
mod_intake_summary_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_intake_summary_ui("intake_summary_ui_1")
    
## To be copied in the server
# mod_intake_summary_server("intake_summary_ui_1")
