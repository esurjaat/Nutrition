#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session) {
  # File Uploads
  upload_ingredients <- mod_fileInput_server("fileInput_ui_ingredients")
  upload_recipes <- mod_fileInput_server("fileInput_ui_recipes")
  upload_log <- mod_fileInput_server("fileInput_ui_log")
  
  # Your application server logic 
  fdc_inputs <- mod_fdc_lookupParameters_server("fdc_lookupParameters_ui_1")
  fdc_table <- mod_fdc_lookupTable_server("fdc_lookupTable_ui_1", fdc_inputs = fdc_inputs)
  user_upload <- mod_ing_selfUpload_server("ing_selfUpload_ui_1")
  ingredients_library <- mod_ing_libraryTable_server("ing_libraryTable_ui_1", fdc_table = fdc_table, user_upload = user_upload, upload = upload_ingredients)
  recipes_add <- mod_recipe_add_server("recipe_add_ui_1", ingredients_library = ingredients_library)
  recipes_library <- mod_recipes_library_server("recipes_library_ui_1", recipes_add = recipes_add, upload = upload_recipes)
  log <- mod_log_server("log_ui_1", ingredients_library = ingredients_library, recipes_library = recipes_library, upload = upload_log)
  mod_downloadButton_server("downloadButton_ui_ingredients", name = "Ingredients", data = ingredients_library)
  mod_downloadButton_server("downloadButton_ui_recipes", name = "Recipes", data = recipes_library)
  mod_downloadButton_server("downloadButton_ui_log", name = "Food Log", data = log)
  
  # Data Viz ====
  barchart_sidebar <- mod_viz_barchart_sidebar_server("viz_barchart_sidebar_ui_1")
  barchart <- mod_viz_barchart_server("viz_barchart_ui_1", log = log, barchart_sidebar = barchart_sidebar)
  
  scatter_meal_sidebar <- mod_viz_scatter_meal_sidebar_server("viz_scatter_meal_sidebar_ui_1")
  scatter <- mod_viz_scatter_meal_server("viz_scatter_meal_ui_1", log = log, scatter_meal_sidebar = scatter_meal_sidebar)
  
  # Test Tab ====
  recipeLookup_inputs <- mod_recipeLookup_inputs_server("recipeLookup_inputs_1")
  recipeLookup_table <- mod_recipeLookup_table_server("recipeLookup_table_1", recipeLookup_inputs = recipeLookup_inputs)
  
}
   