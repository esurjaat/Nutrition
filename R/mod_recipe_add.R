#' recipe_add UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_recipe_add_ui <- function(id){
  ns <- NS(id)
  tagList(
    sidebarLayout(
      sidebarPanel(
        width = 3,
        fluid = TRUE,
        h2("Recipe Entry"),
        textInput(ns("name"), label = "Recipe Name"),
        textInput(ns("category"), label = "Recipe Category"),
        selectInput(ns("food_category"),label = "Food Category", choices = NULL),
        selectInput(ns("description"), label = "Ingredient", choices = NULL),
        numericInput(ns("amount"), label = "Amount", value = 0, min = 0),
        selectInput(ns("measurement"), label = "Measurement", choices = c("grams"), selected = "grams"),
        actionButton(ns("add"), label = "Add Ingredient")
      ),
      mainPanel(
        width = 9,
        h2("Recipe Ingredients List"),
        h6("Please add all ingredients involved in the recipe then click 'Add to Library' below to add the recipe to your Library"),
        DT::DTOutput(ns("table")),
        actionButton(ns("add_library"), label = "Add to Library")
      )
    )
  )
}
    
#' recipe_add Server Functions
#'
#' @noRd 
mod_recipe_add_server <- function(id, ingredients_library){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    table <- reactive({
      ingredients_library$table() %>% 
        mutate(id = paste0(description, " [", brand_name, "]"))
    })
    
    observeEvent(ingredients_library$table(), {
      updateSelectInput(session = session,
                        inputId = "food_category",
                        choices = ingredients_library$table() %>% 
                          distinct(food_category) %>% 
                          arrange(food_category) %>% 
                          pull(food_category))
    })
    
    observeEvent(input$food_category, {
      updateSelectInput(session = session,
                        inputId = "description",
                        choices = table() %>% filter(food_category == input$food_category) %>% arrange(id) %>% pull(id))
    })
    
    observeEvent(ingredients_library$table(), {
      updateSelectInput(session = session,
                        inputId = "description",
                        choices = table() %>% filter(food_category == input$food_category) %>% arrange(id) %>% pull(id))
    })
    
    r <- reactiveValues(df_selected = tibble(recipe_name = character(), 
                                             recipe_category = character(),
                                             amount = numeric(),
                                             amount_measurement = character(),
                                             id = character()))
    observeEvent(input$add, {
      r$df_selected <- 
        bind_rows(isolate(r$df_selected),
                  tibble(recipe_name = input$name, 
                         recipe_category = input$category,
                         amount = input$amount,
                         amount_measurement = input$measurement,
                         id = input$description) %>% 
                    left_join(table(), by = "id") %>%
                    mutate(across(.cols = `Calories (kcal)`:`Fiber (g)`,
                                  .fns = function(x){amount / serving_size * x})))
      })
    
    output$table <- 
      DT::renderDT({ 
        r$df_selected %>% 
          titler()
        })
    
    return(
      list(
        table = reactive({ r$df_selected }),
        recipe_addButton = reactive({ input$add_library })
      )
    )
 
  })
}
    
## To be copied in the UI
# mod_recipe_add_ui("recipe_add_ui_1")
    
## To be copied in the server
# mod_recipe_add_server("recipe_add_ui_1", ingredients_library)
