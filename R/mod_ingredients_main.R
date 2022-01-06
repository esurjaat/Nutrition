#' ingredients_main UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_ingredients_main_ui <- function(id){
  ns <- NS(id)
  tagList(
    h1("Ingredients"),
    tabsetPanel(
      tabPanel(title = "Current Library"),
      tabPanel(title = "Upload Ingredients",
               mod_ingredients_upload_ui("ingredients_upload_ui_1"))
    )
 
  )
}
    
#' ingredients_main Server Functions
#'
#' @noRd 
mod_ingredients_main_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    mod_ingredients_upload_server("ingredients_upload_ui_1")
  })
}
    
## To be copied in the UI
# mod_ingredients_main_ui("ingredients_main_ui_1")
    
## To be copied in the server
# mod_ingredients_main_server("ingredients_main_ui_1")
