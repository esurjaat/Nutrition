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
      selectInput(inputId = ns("ingredient"),
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
                        label = "Log"),
    DT::DTOutput(outputId = ns("test")),
    textOutput(outputId = ns("text"))
  )
}
    
#' intake_log Server Functions
#'
#' @noRd 
mod_intake_log_server <- function(id, ingredients){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    # Update Ingredients ====
    ingredients <- reactiveValues()
    ingredients$selected <- character()
    
    ingredients_reactive <- eventReactive(ingredients(), {
      ingredients() %>% 
        pull(description)
    })
    
    observeEvent(ingredients_reactive(), {
      isolate(ingredients$selected <- ingredients_reactive())
    })
    
    observeEvent(ingredients$selected, {
      updateSelectInput(session = session,
                        inputId = "ingredient",
                        choices = ingredients$selected)
    })
    
    
    # Test ====
    output$test <- 
      DT::renderDT({
        ingredients$selected %>% as_tibble()
      })
    
    
 
  })
}
    
## To be copied in the UI
# mod_intake_log_ui("intake_log_ui_1")
    
## To be copied in the server
# mod_intake_log_server("intake_log_ui_1")
