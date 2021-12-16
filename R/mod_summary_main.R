#' summary_main UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_summary_main_ui <- function(id){
  ns <- NS(id)
  tagList(
    h1("Summary"),
    tabsetPanel(
      tabPanel(title = "Nutritional Intake"),
      tabPanel(title = "Library")
    )
  )
}
    
#' summary_main Server Functions
#'
#' @noRd 
mod_summary_main_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_summary_main_ui("summary_main_ui_1")
    
## To be copied in the server
# mod_summary_main_server("summary_main_ui_1")
