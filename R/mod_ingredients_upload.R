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
  # Define Functions ====
  ns <- NS(id)
  ns_paste <- function(inputId, value){paste0("input[\'", ns(inputId), "\'] == \'", value,"\'")}
  
  # Taglist ====
  tagList(
    br(),
    selectInput(inputId = ns("source"),
                         label = "Source",
                         choices = c("Food Data Central", "Self-Upload"),
                         selected = NULL),
    # Conditional (Source: Self Upload) ====
    conditionalPanel(condition = ns_paste(inputId = "source", value = "Self-Upload"),
                     hr(),
                     br(),
                     textInput(inputId = ns("ingredient_name"),
                               label =  "Name",
                               value = NULL),
                     selectInput(inputId = ns("ingredient_type"),
                                 label = "Type",
                                 choices = c("Fresh", "Packaged"),
                                 selected = "Fresh"),
                     textInput(inputId = ns("ingredient_brand"),
                               label = "Brand",
                               value = NULL),
                     numericInput(inputId = ns("ingredients_calories"),
                                  label = "Calories",
                                  value = 0,
                                  min = 0),
                     numericInput(inputId = ns("ingredients_carbohydrates"),
                                  label = "Carbohydrates",
                                  value = 0,
                                  min = 0),
                     numericInput(inputId = ns("ingredients_fats"),
                                  label = "Fats",
                                  value = 0,
                                  min = 0),
                     numericInput(inputId = ns("ingredients_proteins"),
                                  label = "Proteins",
                                  value = 0,
                                  min = 0),
                     selectInput(inputId = ns("ingredients_measurement"),
                                 label = "Measurement",
                                 choices = c("Grams"),
                                 selected = "Grams"),
                     br(),
                     actionButton(inputId = ns("add_self"),
                                  label = "Add")
                     ),
    # Conditional (Source = FDC) ====
    conditionalPanel(condition = ns_paste(inputId = "source", value = "Food Data Central"),
                     hr(),
                     br(),
                     sidebarLayout(
                       sidebarPanel(
                         mod_fdc_lookupParameters_ui("fdc_lookupParameters_ui_1")
                         ),
                       mainPanel(
                         br(),
                         h2("Lookup Results"),
                         br(),
                         mod_fdc_lookupTable_ui("fdc_lookupTable_ui_1")
                         )
                       )
                     )
    )
    
}
    
#' ingredients_upload Server Functions
#'
#' @noRd 
mod_ingredients_upload_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    fdc_inputs <- mod_fdc_lookupParameters_server("fdc_lookupParameters_ui_1")
    fdc_table <- mod_fdc_lookupTable_server("fdc_lookupTable_ui_1", fdc_inputs = fdc_inputs)
    
    return(
      list(
        fdc_inputs = reactive({ fdc_inputs() }),
        fdc_table = reactive({ fdc_table() })
      )
    )
    
    
  })
}
    
## To be copied in the UI
# mod_ingredients_upload_ui("ingredients_upload_ui_1")
    
## To be copied in the server
# mod_ingredients_upload_server("ingredients_upload_ui_1")




