#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # Your application server logic 
  mod_summary_main_server("summary_main_ui_1")
  mod_recipes_main_server("recipes_main_ui_1")
  mod_ingredients_main_server("ingredients_main_ui_1")
}
