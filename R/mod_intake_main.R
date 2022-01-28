#' intake_main UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_intake_main_ui <- function(id){
  ns <- NS(id)
  tagList(
    h1("Nutritional Intake"),
    tabsetPanel(
      tabPanel(title = "Summary"),
      tabPanel(title = "Log",
               mod_intake_log_ui(ns("intake_log_ui_1")))
    )
  )
}
    
#' intake_main Server Functions
#'
#' @noRd 
mod_intake_main_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
  })
}
    
## To be copied in the UI
# mod_intake_main_ui("intake_main_ui_1")
    
## To be copied in the server
# mod_intake_main_server("intake_main_ui_1")
