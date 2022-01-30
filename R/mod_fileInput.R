#' fileInput UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_fileInput_ui <- function(id){
  ns <- NS(id)
  tagList(
    fileInput(ns("upload"), label = NULL, buttonLabel = "Upload", placeholder = "Up")
  )
}
    
#' fileInput Server Functions
#'
#' @noRd 
mod_fileInput_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    table <- eventReactive(input$upload, {
      input$upload$datapath %>% 
        read_csv()
    })
    
    return(
      list(
        table = reactive({ table() })
      )
    )
 
  })
}
    
## To be copied in the UI
# mod_fileInput_ui("fileInput_ui_1")
    
## To be copied in the server
# mod_fileInput_server("fileInput_ui_1")
