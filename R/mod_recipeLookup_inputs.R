#' recipeLookup_inputs UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_recipeLookup_inputs_ui <- function(id){
  ns <- NS(id)
  tagList(
    textInput(inputId = ns("url"), label = "Allrecipes URL", value = ""),
    actionButton(inputId = ns("add"), label = "Add")
  )
}
    
#' recipeLookup_inputs Server Functions
#'
#' @noRd 
mod_recipeLookup_inputs_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    df <- 
      eventReactive(input$add, {
        get_allrecipes(url = input$url)
      })
    
    
    return(
      list(
        url = reactive({ input$url }),
        add = reactive({ input$add }),
        df = reactive({ df() })
      )
    )
 
  })
}
    
## To be copied in the UI
# mod_recipeLookup_inputs_ui("recipeLookup_inputs_1")
    
## To be copied in the server
# mod_recipeLookup_inputs_server("recipeLookup_inputs_1")
