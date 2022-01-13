#' ingredients_library UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_ingredients_library_ui <- function(id){
  ns <- NS(id)
  tagList(
    br(),
    h1("My Ingredients Library"),
    DT::DTOutput(outputId = ns("library_table")),
  )
}
    
#' ingredients_library Server Functions
#'
#' @noRd 
mod_ingredients_library_server <- function(id, add_fdcIds, add_button, api_key){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    # Library Table (Base) ====
    table_library <- reactiveValues()
    table_library$df <- tibble(
      food_category = character(),
      description = character(),
      source = character(),
      data_type = character(),
      upc = character(),
      brand_name = character(),
      brand_owner = character(),
      `Calories (kcal)` = numeric(),
      `Protein (g)` = numeric(),
      `Carbohydrates (g)` = numeric(),
      `Total Fat (g)` = numeric(),
      `Trans Fats (g)` = numeric(),
      `Saturated Fats (g)` = numeric(),
      `Sodium (mg)` = numeric(),
      `Fiber (g)` = numeric()
    )
    
    # Ingredients to be Added ====
    new_ingredients <- eventReactive(add_button(),{
      fdc_shape_id(api_key = api_key(),
                   fdc_ids = add_fdcIds()) %>% 
        mutate(source = "Food Data Central") %>% 
        select(food_category, description, source, everything()) %>% 
        select(-c(fdc_id, food_class))
    })
    
    observeEvent(new_ingredients(), {
      isolate(table_library$df <- bind_rows(table_library$df, new_ingredients()))
    })
    
    output$library_table <- 
      DT::renderDT({
        table_library$df
      })
 
  })
}
    
## To be copied in the UI
# mod_ingredients_library_ui("ingredients_library_ui_1")
    
## To be copied in the server
# mod_ingredients_library_server("ingredients_library_ui_1")
