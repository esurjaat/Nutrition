#' ingredients_upload UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_ingredients_upload_ui <- function(id){
  ns <- NS(id)
  tagList(
    textInput(inputId = "ingredient_name",
              label =  "Name",
              value = NULL),
    selectInput(inputId = "ingredient_type",
                label = "Type",
                choices = c("Fresh", "Packaged"),
                selected = "Fresh"),
    textInput(inputId = "ingredient_brand",
              label = "Brand",
              value = NULL),
    numericInput(inputId = "ingredients_calories",
                 label = "Calories",
                 value = 0,
                 min = 0),
    numericInput(inputId = "ingredients_carbohydrates",
                 label = "Carbohydrates",
                 value = 0,
                 min = 0),
    numericInput(inputId = "ingredients_fats",
                 label = "Fats",
                 value = 0,
                 min = 0),
    numericInput(inputId = "ingredients_proteins",
                 label = "Proteins",
                 value = 0,
                 min = 0),
    selectInput(inputId = "ingredients_measurement",
                label = "Measurement",
                choices = c("Grams"),
                selected = "Grams"),
    br(),
    actionButton(inputId = "ingredients_upload",
                 label = "Add")
  )
}
    
#' ingredients_upload Server Functions
#'
#' @noRd 
mod_ingredients_upload_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_ingredients_upload_ui("ingredients_upload_ui_1")
    
## To be copied in the server
# mod_ingredients_upload_server("ingredients_upload_ui_1")
