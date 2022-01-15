#' intake_log UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_intake_log_ui <- function(id){
  ns <- NS(id)
  ns_paste <- function(inputId, value){paste0("input[\'", ns(inputId), "\'] == \'", value,"\'")}
  
  tagList(
    h1("What did you eat?"),
    shiny::dateInput(inputId = ns("date"),
                     label = "Date",
                     value = Sys.Date()),
    shiny::selectInput(inputId = ns("type"),
                       label = "Type",
                       choices = c("Ingredient", "Recipe")),
    conditionalPanel(
      condition = ns_paste(inputId = "type", value = "Ingredient"),
      selectInput(inputId = ns("Ingredient"),
                  label = "Ingredient",
                  choices = NULL,
                  selected = NULL)
    ),
    shiny::numericInput(inputId = ns("amount"),
                        label = "Amount",
                        value = 0,
                        min = 0),
    shiny::selectInput(inputId = ns("measurement"),
                       label = "Measurement",
                       choices = c("Grams (g)"),
                       selected = "Grams (g)"),
    shiny::actionButton(inputId = ns("log"),
                        label = "Log")
  )
}
    
#' intake_log Server Functions
#'
#' @noRd 
mod_intake_log_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    
 
  })
}
    
## To be copied in the UI
# mod_intake_log_ui("intake_log_ui_1")
    
## To be copied in the server
# mod_intake_log_server("intake_log_ui_1")
