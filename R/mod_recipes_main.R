#' recipes_main UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_recipes_main_ui <- function(id){
  ns <- NS(id)
  tagList(
    h1("Recipes"),
    tabsetPanel(
      tabPanel(title = "Current Library"),
      tabPanel(title = "Upload Recipe")
    )
  )
}
    
#' recipes_main Server Functions
#'
#' @noRd 
mod_recipes_main_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_recipes_main_ui("recipes_main_ui_1")
    
## To be copied in the server
# mod_recipes_main_server("recipes_main_ui_1")
