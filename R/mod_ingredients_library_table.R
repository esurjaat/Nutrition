#' ingredients_library_table UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_ingredients_library_table_ui <- function(id){
  ns <- NS(id)
  tagList(
    DT::DTOutput(outputId = ns("library_table"))
    )
}
    
#' ingredients_library_table Server Functions
#'
#' @noRd 
mod_ingredients_library_table_server <- function(id, fdc){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
  
    
 
  })
}
    
## To be copied in the UI
# mod_ingredients_library_table_ui("ingredients_library_table_ui_1")
    
## To be copied in the server
# mod_ingredients_library_table_server("ingredients_library_table_ui_1")
