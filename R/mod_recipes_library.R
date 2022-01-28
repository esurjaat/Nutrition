#' recipes_library UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_recipes_library_ui <- function(id){
  ns <- NS(id)
  ns_paste <- function(inputId, value){paste0("input[\'", ns(inputId), "\'] == \'", value,"\'")}
  
  tagList(
    br(),
    fluidRow(selectInput(ns("type"), 
                         label = "View Type", 
                         choices = c("Detail", "Summary"),
                         selected = "Detail")),
    hr(),
    br(),
    conditionalPanel(condition = ns_paste(inputId = "type", value = "Detail"),
                     h2("Recipes (Detailed)"),
                     DT::DTOutput(ns("detail"))),
    conditionalPanel(condition = ns_paste(inputId = "type", value = "Summary"),
                     h2("Recipes (Summary)"),
                     DT::DTOutput(ns("summary")))
  )
}
    
#' recipes_library Server Functions
#'
#' @noRd 
mod_recipes_library_server <- function(id, recipes_add){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    library <- 
      reactiveValues(detail = NULL)
    
    observeEvent(recipes_add$recipe_addButton(), {
      library$detail <- bind_rows(isolate(library$detail), recipes_add$table()) %>% unique()
    })
    
    summary <- reactive({
      library$detail %>% 
        group_by(recipe_name, recipe_category) %>% 
        summarise(across(.cols = `Calories (kcal)`:`Fiber (g)`, 
                         .fns = function(x){sum(x)}))
    })
    
    output$detail <-
      DT::renderDT({
        req(recipes_add$recipe_addButton())
        library$detail %>% 
          titler()
      })
    
    output$summary <- 
      DT::renderDT({
        req(summary())
        summary() %>% 
          titler()
      })
    
    return(
      list(
        detail = reactive({ library$detail }),
        summary = reactive({ summary() })
      )
    )
    
  })
}
    
## To be copied in the UI
# mod_recipes_library_ui("recipes_library_ui_1")
    
## To be copied in the server
# mod_recipes_library_server("recipes_library_ui_1", recipes_add)
