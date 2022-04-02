#' recipeLookup_table UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_recipeLookup_table_ui <- function(id){
  ns <- NS(id)
  tagList(
    DT::DTOutput(outputId = ns("table")),
    actionButton(inputId = ns("add"), label = "Add to Shopping List"),
  )
}
    
#' recipeLookup_table Server Functions
#'
#' @noRd 
mod_recipeLookup_table_server <- function(id, recipeLookup_inputs){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    output$table <- 
      DT::renderDT({
        datatable(
          recipeLookup_inputs$df(),
          editable = TRUE,
          options = list(
            scrollX = TRUE
          )
          )
        })
    
    
 
  })
}
    
## To be copied in the UI
# mod_recipeLookup_table_ui("recipeLookup_table_1")
    
## To be copied in the server
# mod_recipeLookup_table_server("recipeLookup_table_1", recipeLookup_inputs)
