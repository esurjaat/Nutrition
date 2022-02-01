#' viz_scatter_meal_sidebar UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_viz_scatter_meal_sidebar_ui <- function(id){
  ns <- NS(id)
  tagList(
    dateRangeInput(ns("date_range"),
                   label = "Date Range", 
                   start = lubridate::ymd("2022-01-31"), 
                   end = lubridate::ymd("2022-02-06")),
    selectInput(ns("x_var"), 
                label = "X-Axis", 
                choices = c("Total", "Protein", "Carbohydrates", "Fats"), 
                selected = "Total"),
    selectInput(ns("y_var"),
                label = "Y-Axis",
                choices = c("Total", "Protein", "Carbohydrates", "Fats"),
                selected = "Protein")
  )
}
    
#' viz_scatter_meal_sidebar Server Functions
#'
#' @noRd 
mod_viz_scatter_meal_sidebar_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    return(
      list(
        date_range = reactive({ input$date_range }),
        x_var = reactive({ input$x_var }),
        y_var = reactive({ input$y_var })
      )
    )
  })
}
    
## To be copied in the UI
# mod_viz_scatter_meal_sidebar_ui("viz_scatter_meal_sidebar_ui_1")
    
## To be copied in the server
# mod_viz_scatter_meal_sidebar_server("viz_scatter_meal_sidebar_ui_1")
