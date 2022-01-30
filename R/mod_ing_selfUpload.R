#' ing_selfUpload UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_ing_selfUpload_ui <- function(id){
  ns <- NS(id)
  tagList(
    column(3,
           h2("Food Description"),
           textInput(ns("food_category"), label = "Food Category"),
           textInput(ns("description"), label = "Description"),
           textInput(ns("upc"), label = "UPC"),
           textInput(ns("brand_name"), label = "Brand Name"),
           textInput(ns("brand_owner"), label = "Brand Owner")),
    column(3,
           h2("Serving Info"),
           numericInput(ns("serving_size"),label = "Serving Size", value = 0, min = 0),
           selectInput(ns("measurement"), label = "Measurement", choices = c("grams"), selected = "grams")),
    column(3,
           h2("Nutrition Facts"),
           numericInput(ns("calories"), label = "Calories (Kcal)", value = 0, min = 0, step = 10),
           numericInput(ns("protein"), label = "Protein (g)", value = 0, min = 0, step = 1),
           numericInput(ns("carbohydrates"), label = "Carbohydrates (g)", value = 0, min = 0, step = 1),
           numericInput(ns("total_fat"), label = "Total Fat (g)", value = 0, min = 0, step = 1),
           numericInput(ns("trans_fats"), label = "Trans Fats (g)", value = 0, min = 0, step = 1),
           numericInput(ns("saturated_fats"), label = "Saturated Fats (g)", value = 0, min = 0, step = 1),
           numericInput(ns("sodium"), label = "Sodium (Mg)", value = 0, min = 0, step = 100),
           numericInput(ns("fiber"), label = "Fiber (g)", value = 0, min = 0, step = 1)),
    column(3,
           actionButton(ns("add"),label = "Add to Library"))
  )
}
    
#' ing_selfUpload Server Functions
#'
#' @noRd 
mod_ing_selfUpload_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    observeEvent(input$add, {
      updateTextInput(session = session, inputId = "food_category", value = "")
      updateTextInput(session = session, inputId = "description", value = "")
      updateTextInput(session = session, inputId = "upc", value = "")
      updateTextInput(session = session, inputId = "brand_name", value = "")
      updateTextInput(session = session, inputId = "brand_owner", value = "")
      updateNumericInput(session = session, inputId = "serving_size", value = "")
      updateSelectInput(session = session, inputId = "measurement", selected = "grams")
      updateNumericInput(session = session, inputId = "calories", value = 0)
      updateNumericInput(session = session, inputId = "protein", value = 0)
      updateNumericInput(session = session, inputId = "carbohydrates", value = 0)
      updateNumericInput(session = session, inputId = "total_fat", value = 0)
      updateNumericInput(session = session, inputId = "trans_fats", value = 0)
      updateNumericInput(session = session, inputId = "saturated_fats", value = 0)
      updateNumericInput(session = session, inputId = "sodium", value = 0)
      updateNumericInput(session = session, inputId = "fiber", value = 0)
    })
    
    return(
      list(
        entry = reactive({
          tibble(
            fdc_id = as.character(NA),
            food_category = input$food_category,
            description = input$description,
            source = as.character("Self-Upload"),
            data_type = as.character(NA),
            upc = input$upc,
            brand_name = input$brand_name,
            brand_owner = input$brand_owner,
            serving_size = input$serving_size,
            measurement = input$measurement,
            `Calories (kcal)` = input$calories,
            `Protein (g)` = input$protein,
            `Carbohydrates (g)` = input$carbohydrates,
            `Total Fat (g)` = input$total_fat,
            `Trans Fats (g)` = input$trans_fats,
            `Saturated Fats (g)` = input$saturated_fats,
            `Sodium (mg)` = input$sodium,
            `Fiber (g)` = input$fiber)
          }),
        add = reactive({ input$add })
      )
    )
 
  })
}
    
## To be copied in the UI
# mod_ing_selfUpload_ui("ing_selfUpload_ui_1")
    
## To be copied in the server
# mod_ing_selfUpload_server("ing_selfUpload_ui_1")
