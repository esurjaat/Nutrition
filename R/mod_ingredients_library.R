#' ingredients_library UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_ingredients_library_ui <- function(id){
  ns <- NS(id)
  tagList(
    br(),
    sidebarLayout(
      sidebarPanel(
        shiny::fileInput(inputId = ns("library_upload"),
                         label = "Upload Library",
                         multiple = FALSE),
        shiny::downloadButton(outputId = ns("library_download"),
                              label = "Download Library"),
      ),
      mainPanel(
        h1("Library"),
        br(),
        DT::DTOutput(outputId = ns("library_table")) %>% 
          shinycssloaders::withSpinner(),
        actionButton(inputId = ns("remove_ingredients"),
                     label = "Remove Selected")
      )
    )
  )
}
    
#' ingredients_library Server Functions
#'
#' @noRd 
mod_ingredients_library_server <- function(id, add_fdcIds, add_button, api_key){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    # Library Table (Base) ====
    table_library <- reactiveValues()
    table_library$df <- tibble(
      fdc_id = character(),
      food_category = character(),
      description = character(),
      source = character(),
      data_type = character(),
      upc = character(),
      brand_name = character(),
      brand_owner = character(),
      `Calories (kcal)` = numeric(),
      `Protein (g)` = numeric(),
      `Carbohydrates (g)` = numeric(),
      `Total Fat (g)` = numeric(),
      `Trans Fats (g)` = numeric(),
      `Saturated Fats (g)` = numeric(),
      `Sodium (mg)` = numeric(),
      `Fiber (g)` = numeric()
    )
    
    # Ingredients to be Added ====
    new_ingredients <- eventReactive(add_button(),{
      fdc_shape_id(api_key = api_key(),
                   fdc_ids = add_fdcIds()) %>% 
        mutate(source = "Food Data Central") %>% 
        select(fdc_id, food_category, description, source, everything()) %>% 
        select(-c(food_class))
    })
    
    observeEvent(new_ingredients(), {
      isolate(table_library$df <- bind_rows(table_library$df, new_ingredients()) %>% unique())
    })
    
    output$library_table <- 
      DT::renderDT({
        table_library$df %>% 
          select(-fdc_id) %>% 
          titler() 
      })
    
    # Removing ingredients ====
    fdcId_selected <- eventReactive(input$library_table_rows_selected, {
      if(length(input$library_table_rows_selected) > 0){
        table_library$df %>% 
          .[input$library_table_rows_selected, ] %>% 
          pull(fdc_id)
      } 
    })
    
    observeEvent(input$remove_ingredients, {
      isolate(table_library$df <-
                table_library$df %>% 
                filter(!(fdc_id %in% fdcId_selected())))
    })
    
    # Upload Library ====
    library <- eventReactive(input$library_upload, {
      input$library_upload$datapath %>% 
        read_csv()
    })
    
    observeEvent(library(), {
      isolate(table_library$df <- bind_rows(table_library$df, library()) %>% unique())
    })
    
    
    
    
    # Download Library ====
    output$library_download <- 
      downloadHandler(
        filename = "testing.csv",
        content = function(file){
          write.csv(table_library$df, file)
        },
        contentType = "text/csv"
      )

 
  })
}
    
## To be copied in the UI
# mod_ingredients_library_ui("ingredients_library_ui_1")
    
## To be copied in the server
# mod_ingredients_library_server("ingredients_library_ui_1")
