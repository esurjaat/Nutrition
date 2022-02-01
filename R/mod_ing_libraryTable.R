#' ing_libraryTable UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_ing_libraryTable_ui <- function(id){
  ns <- NS(id)
  tagList(
    DT::DTOutput(ns("table")) %>% shinycssloaders::withSpinner(),
    actionButton(ns("remove"), label = "Remove")
  )
}
    
#' ing_libraryTable Server Functions
#'
#' @noRd 
mod_ing_libraryTable_server <- function(id, fdc_table, user_upload, upload){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    library_reactives <- 
      reactiveValues(
        df = tibble(
          fdc_id = character(),
          food_category = character(),
          description = character(),
          source = character(),
          data_type = character(),
          upc = character(),
          brand_name = character(),
          brand_owner = character(),
          serving_size = numeric(),
          measurement = character(),
          `Calories (kcal)` = numeric(),
          `Protein (g)` = numeric(),
          `Carbohydrates (g)` = numeric(),
          `Total Fat (g)` = numeric(),
          `Trans Fats (g)` = numeric(),
          `Saturated Fats (g)` = numeric(),
          `Sodium (mg)` = numeric(),
          `Fiber (g)` = numeric()
          ))
    
    observeEvent(fdc_table$fdc_addButton(), {
      library_reactives$df <- bind_rows(isolate(library_reactives$df), fdc_table$fdc_new_ingredients()) %>% unique()
    })
    
    observeEvent(input$remove, {
      library_reactives$df <- 
        library_reactives$df %>% 
        .[-input$table_rows_selected, ]
    })
    
    observeEvent(user_upload$add(), {
      library_reactives$df <- bind_rows(isolate(library_reactives$df), user_upload$entry()) %>% unique()
    })
    
    observeEvent(upload$table(), {
      library_reactives$df <- 
        bind_rows(library_reactives$df, 
                  upload$table() %>% 
                    mutate(fdc_id = as.character(fdc_id),
                           upc = as.character(upc))) %>%
        unique()
    })
    
    output$table <- 
      DT::renderDT({
        library_reactives$df %>% 
          titler()
      })
    
    return(
      list(
        table = reactive({ library_reactives$df })
      )
    )
 
  })
}
    
## To be copied in the UI
# mod_ing_libraryTable_ui("ing_libraryTable_ui_1")
    
## To be copied in the server
# mod_ing_libraryTable_server("ing_libraryTable_ui_1", fdc_table)
