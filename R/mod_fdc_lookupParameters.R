#' fdc_lookupParameters UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_fdc_lookupParameters_ui <- function(id){
  ns <- NS(id)
  tagList(
    textInput(inputId = ns("fdc_searchTerm"),
              label = "Search Term",
              value = NA),
    textInput(inputId = ns("fdc_api"),
              label = "API Key",
              value = NA),
    radioButtons(inputId = ns("fdc_dataType"),
                 label = "Data Type",
                 choices = c("Branded", "Measured"),
                 selected = "Branded"),
    actionButton(inputId = ns("fdc_searchButton"),
                 label = "Search")
  )
}
    
#' fdc_lookupParameters Server Functions
#'
#' @noRd 
mod_fdc_lookupParameters_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    return(
      list(
        fdc_searchTerm = reactive({ input$fdc_searchTerm }),
        fdc_api = reactive({ input$fdc_api }),
        fdc_dataType = reactive({ input$fdc_dataType }),
        fdc_searchButton = reactive({ input$fdc_searchButton })
      )
    )
 
  })
}
    
## To be copied in the UI
# mod_fdc_lookupParameters_ui("fdc_lookupParameters_ui_1")
    
## To be copied in the server
# mod_fdc_lookupParameters_server("fdc_lookupParameters_ui_1")
