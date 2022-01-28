#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session) {
  # Your application server logic 
  fdc_inputs <- mod_fdc_lookupParameters_server("fdc_lookupParameters_ui_1")
  fdc_table <- mod_fdc_lookupTable_server("fdc_lookupTable_ui_1", fdc_inputs = fdc_inputs)
  user_upload <- mod_ing_selfUpload_server("ing_selfUpload_ui_1")
  ingredients_library <- mod_ing_libraryTable_server("ing_libraryTable_ui_1", fdc_table = fdc_table, user_upload = user_upload)
  recipes_add <- mod_recipe_add_server("recipe_add_ui_1", ingredients_library = ingredients_library)
  recipes_library <- mod_recipes_library_server("recipes_library_ui_1", recipes_add = recipes_add)
  mod_log_server("log_ui_1", ingredients_library = ingredients_library, recipes_library = recipes_library)
}
   