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
    sidebarLayout(
      sidebarPanel(
        width = 3,
        h2("Controls"),
        radioButtons(ns("type"), 
                    label = "Table Type", 
                    choices = c("Summary", "Detail"),
                    selected = "Summary", inline = TRUE)
      ),
      mainPanel(
        width = 9,
        h2("Recipe Libary"),
        conditionalPanel(condition = ns_paste(inputId = "type", value = "Detail"),
                         DT::DTOutput(ns("detail"))),
        conditionalPanel(condition = ns_paste(inputId = "type", value = "Summary"),
                         DT::DTOutput(ns("summary")))
        )
      )
  )
}
    
#' recipes_library Server Functions
#'
#' @noRd 
mod_recipes_library_server <- function(id, recipes_add, upload){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    library <- 
      reactiveValues(detail = NULL)
    
    observeEvent(recipes_add$recipe_addButton(), {
      library$detail <- bind_rows(isolate(library$detail), recipes_add$table() %>% mutate(upc = as.character(upc))) %>% unique()
    })
    
    observeEvent(upload$table(), {
      library$detail <- 
        bind_rows(isolate(library$detail), 
                  upload$table() %>% 
                    mutate(fdc_id = as.character(fdc_id),
                           upc = as.character(upc))) %>% 
        unique()
    })
    
    summary <- reactive({
      req(library$detail)
      library$detail %>% 
        group_by(recipe_name, recipe_category) %>% 
        summarise(across(.cols = `Calories (kcal)`:`Fiber (g)`, 
                         .fns = function(x){sum(x)}))
    })
    
    output$detail <-
      DT::renderDT({
        req(nrow(library$detail > 0))
        library$detail %>% 
          titler()
      })
    
    output$summary <- 
      DT::renderDT({
        req(summary())
        summary() %>% 
          titler()
      })
    
    # Load Sample Data ====
    observe({
      library$detail <- read_csv("data/Recipes - 2022-01-31.csv")
    })
    
    return(
      list(
        table = reactive({ library$detail }),
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
