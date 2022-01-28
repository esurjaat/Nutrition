#' fdc_lookupTable UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_fdc_lookupTable_ui <- function(id){
  ns <- NS(id)
  tagList(
    DT::DTOutput(outputId = ns("fdc_lookupTable")) %>% shinycssloaders::withSpinner(),
    br(),
    actionButton(inputId = ns("add_fdc"),
                 label = "Add")
  )
}
    
#' fdc_lookupTable Server Functions
#'
#' @noRd 
mod_fdc_lookupTable_server <- function(id, fdc_inputs){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    fdc_lookupTable <- 
      eventReactive(fdc_inputs$fdc_searchButton(), {
        fdc_shape_search(
          api_key = fdc_inputs$fdc_api(),
          search_term = fdc_inputs$fdc_searchTerm(),
          data_type = fdc_inputs$fdc_dataType(),
          page_size = 1000
        )
      })
    
    fdc_fdcIds_selected = reactive({ 
      fdc_lookupTable() %>% 
        .[input$fdc_lookupTable_rows_selected, ] %>% 
        pull(fdc_id)
    })
    
    output$fdc_lookupTable <- 
      DT::renderDT({
        req(fdc_inputs$fdc_searchButton())
        fdc_lookupTable()
      })
      
    # Return
    return(
      list(
      fdc_lookupTable = reactive({ fdc_lookupTable() }),
      fdc_lookupTable_selectedRows = reactive({ input$fdc_lookupTable_rows_selected }),
      fdc_fdcIds_selected = reactive({ fdc_fdcIds_selected() }),
      fdc_new_ingredients = reactive({ 
        fdc_shape_id(api_key = fdc_inputs$fdc_api(),
                     fdc_ids = fdc_fdcIds_selected()) %>% 
          mutate(source = "Food Data Central") %>% 
          select(fdc_id, food_category, description, source, everything()) %>% 
          select(-c(food_class))
      }),
      fdc_addButton = reactive({ input$add_fdc })
      )
    )
 
  })
}
    
## To be copied in the UI
# mod_fdc_lookupTable_ui("fdc_lookupTable_ui_1")
    
## To be copied in the server
# mod_fdc_lookupTable_server("fdc_lookupTable_ui_1", fdc_inputs)
