#' downloadButton UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_downloadButton_ui <- function(id){
  ns <- NS(id)
  tagList(
    downloadButton(ns("download"), label = "Download")
  )
}
    
#' downloadButton Server Functions
#'
#' @noRd 
mod_downloadButton_server <- function(id, name, data){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    output$download <- 
      downloadHandler(
        filename = function(){
          paste0(name, " - ", Sys.Date(), ".csv")
        },
        content = function(file){
          write_csv(x = data$table(), file = file)
        }
      )
  })
}
    
## To be copied in the UI
# mod_downloadButton_ui("downloadButton_ui_1")
    
## To be copied in the server
# mod_downloadButton_server("downloadButton_ui_1", name, data)
