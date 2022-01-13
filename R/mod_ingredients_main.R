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
      tabPanel(title = "Current Library",
               mod_ingredients_library_ui(ns("ingredients_library_ui_1"))),
      tabPanel(title = "Upload Ingredients",
               mod_ingredients_upload_ui(ns("ingredients_upload_ui_1")))
    )
 
  )
}
    
#' ingredients_main Server Functions
#'
#' @noRd 
mod_ingredients_main_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    # Define ====
    temp <- mod_ingredients_upload_server("ingredients_upload_ui_1")
    
    # Modules ====
    mod_ingredients_upload_server("ingredients_upload_ui_1")
    mod_ingredients_library_server("ingredients_library_ui_1", 
                                   add_fdcIds = temp$add_fdcIds, 
                                   add_button = temp$add_button, 
                                   api_key = temp$api)
  })
}
    
## To be copied in the UI
# mod_ingredients_main_ui("ingredients_main_ui_1")
    
## To be copied in the server
# mod_ingredients_main_server("ingredients_main_ui_1")
