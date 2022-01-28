#' recipe_library UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_recipe_library_ui <- function(id){
  ns <- NS(id)
  tagList(
    
  )
}
    
#' recipe_library Server Functions
#'
#' @noRd 
mod_recipe_library_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    
    
  })
}
    
## To be copied in the UI
# mod_recipe_library_ui("recipe_library_ui_1")
    
## To be copied in the server
# mod_recipe_library_server("recipe_library_ui_1")
