#' ingredients_upload UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_ingredients_upload_ui <- function(id){
  # Define Functions ====
  ns <- NS(id)
  ns_paste <- function(inputId, value){paste0("input[\'", ns(inputId), "\'] == \'", value,"\'")}
  
  tagList(
    br(),
    shiny::textOutput(outputId = ns("test")),
    selectInput(inputId = ns("source"),
                         label = "Source",
                         choices = c("Food Data Central", "Self-Upload"),
                         selected = NULL),
    conditionalPanel(condition = ns_paste(inputId = "source", value = "Self-Upload"),
                     hr(),
                     br(),
                     textInput(inputId = ns("ingredient_name"),
                               label =  "Name",
                               value = NULL),
                     selectInput(inputId = ns("ingredient_type"),
                                 label = "Type",
                                 choices = c("Fresh", "Packaged"),
                                 selected = "Fresh"),
                     textInput(inputId = ns("ingredient_brand"),
                               label = "Brand",
                               value = NULL),
                     numericInput(inputId = ns("ingredients_calories"),
                                  label = "Calories",
                                  value = 0,
                                  min = 0),
                     numericInput(inputId = ns("ingredients_carbohydrates"),
                                  label = "Carbohydrates",
                                  value = 0,
                                  min = 0),
                     numericInput(inputId = ns("ingredients_fats"),
                                  label = "Fats",
                                  value = 0,
                                  min = 0),
                     numericInput(inputId = ns("ingredients_proteins"),
                                  label = "Proteins",
                                  value = 0,
                                  min = 0),
                     selectInput(inputId = ns("ingredients_measurement"),
                                 label = "Measurement",
                                 choices = c("Grams"),
                                 selected = "Grams"),
                     br(),
                     actionButton(inputId = ns("add_self"),
                                  label = "Add")
                     ),
    conditionalPanel(condition = ns_paste(inputId = "source", value = "Food Data Central"),
                     hr(),
                     br(),
                     sidebarLayout(
                       sidebarPanel(
                         textInput(inputId = ns("searchTerm_text"),
                                   label = "Search Term",
                                   value = NA),
                         textInput(inputId = ns("apiKey_text"),
                                   label = "API Key",
                                   value = NA),
                         radioButtons(inputId = ns("dataType_radio"),
                                      label = "Data Type",
                                      choices = c("Branded", "Measured"),
                                      selected = "Branded"),
                         actionButton(inputId = ns("search_action"),
                                      label = "Search"),
                         hr(),
                         br(),
                         conditionalPanel(condition = ns_paste(inputId = "dataType_radio", value = "Branded"),
                                          h3("Parameters (Branded)"),
                                          ),
                         conditionalPanel(condition = ns_paste(inputId = "dataType_radio", value = "Measured"),
                                          h3("Parameters (Measured)")),
                         actionButton(inputId = ns("search_action"),
                                      label = "Search")
                         ),
                       mainPanel(
                         br(),
                         h2("Lookup Results"),
                         textOutput(outputId = ns("fdc_table_description_text")),
                         br(),
                         DT::DTOutput(outputId = ns("fdc_table")) %>% shinycssloaders::withSpinner(),
                         br(),
                         actionButton(inputId = ns("add_fdc"),
                                      label = "Add"),
                         br(),
                         DT::DTOutput(outputId = ns("fdc_selected")) %>% shinycssloaders::withSpinner()
                         )
                       )
                     )
    )
    
}
    
#' ingredients_upload Server Functions
#'
#' @noRd 
mod_ingredients_upload_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    # Search Term Results ====
    table_search <- eventReactive(input$search_action,{
      fdc_shape_search(api_key = input$apiKey_text,
                       search_term = input$searchTerm_text,
                       data_type = input$dataType_radio,
                       page_size = 1000)
    })
    
    table_results_text <- eventReactive(input$search_action,{
      paste0("Showing results for \'", 
             input$searchTerm_text, 
             "\', under the \'", 
             input$dataType_radio, 
             "\' data type.")
    })
    
    output$fdc_table <- 
      DT::renderDT({
        table_search() %>%
          titler()
      })
    
    output$fdc_table_description_text <- 
      renderText({
        table_results_text()
      })
    
    selected_fdcIds <- eventReactive(input$fdc_table_rows_selected, {
      if(length(input$fdc_table_rows_selected) > 0){
        table_search() %>% 
          .[input$fdc_table_rows_selected, ] %>% 
          pull(fdc_id)
      } 
    })
    
    # ID Lookup ====
    table_id <- eventReactive(input$add_fdc,{
      fdc_shape_id(api_key = input$apiKey_text,
                   fdc_ids = selected_fdcIds())
    })
    
    output$fdc_selected <- 
      DT::renderDT({
        table_id() %>% 
          titler()
      })
    
    return(
      list(
        add_fdcIds = eventReactive(input$fdc_table_rows_selected, {
          if (length(input$fdc_table_rows_selected) > 0) {
            table_search() %>%
              .[input$fdc_table_rows_selected, ] %>%
              pull(fdc_id)
          }
        }), 
        add_button = shiny::reactive(input$add_fdc),
        api = shiny::reactive(input$apiKey_text)
      )
    )
    
  })
}
    
## To be copied in the UI
# mod_ingredients_upload_ui("ingredients_upload_ui_1")
    
## To be copied in the server
# mod_ingredients_upload_server("ingredients_upload_ui_1")





