#' log UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_log_ui <- function(id){
  ns <- NS(id)
  ns_paste <- function(inputId, value){paste0("input[\'", ns(inputId), "\'] == \'", value,"\'")}
  
  tagList(
    sidebarLayout(
      sidebarPanel(
        dateInput(ns("date"), label = "Date", value = Sys.Date()),
        timeInput(ns("time"), label = "Time", value = Sys.time()),
        selectInput(ns("type"), label = "Type", choices = c("Ingredient", "Recipe"), selected = "Ingredient"),
        conditionalPanel(condition = ns_paste(inputId = "type", value = "Ingredient"),
                         selectInput(ns("ingredient_category"), label = "Category", choices = NULL, selected = NULL),
                         selectInput(ns("ingredient_item"), label = "Item", choices = NULL, selected = NULL)),
        conditionalPanel(condition = ns_paste(inputId = "type", value = "Recipe"),
                         selectInput(ns("recipe_category"), label = "Category", choices = NULL, selected = NULL),
                         selectInput(ns("recipe_item"), label = "Item", choices = NULL, selected = NULL),
                         numericInput(ns("recipe_totalWeight"), label = "Total Recipe Weight", value = 0, min = 0)),
        numericInput(ns("amount"), label = "Amount Consumed", value = 0, min = 0, step = 1),
        selectInput(ns("measurement"), label = "Measurement", choices = c("grams"), selected = "grams"),
        actionButton(ns("submit"), label = "Submit")
      ),
      mainPanel(
        selectInput(ns("view_type"), label = "View", choices = c("Table", "Graph"), selected = "Table"),
        conditionalPanel(condition = ns_paste(inputId = "view_type", value = "Table"),
                         DT::DTOutput(ns("table"))),
        conditionalPanel(condition = ns_paste(inputId = "view_type", value = "Graph"),
                         plotOutput(ns("plot")))
      )
    )
  )
}
    
#' log Server Functions
#'
#' @noRd 
mod_log_server <- function(id, ingredients_library, recipes_library){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    # Update Ingredient Choices ====
    observeEvent(ingredients_library$table(), {
      req(ingredients_library$table())
      updateSelectInput(session = session,
                        inputId = "ingredient_category",
                        choices = ingredients_library$table() %>% 
                          distinct(food_category) %>% 
                          arrange(food_category) %>% 
                          pull(food_category))
    })
    observeEvent(input$ingredient_category, {
      req(input$ingredient_category)
      updateSelectInput(session = session,
                        inputId = "ingredient_item",
                        choices = ingredients_library$table() %>% 
                          filter(food_category == input$ingredient_category) %>% 
                          distinct(description) %>% 
                          arrange(description) %>% 
                          pull(description))
    })
    
    # Update Recipe Choices ====
    observeEvent(recipes_library$detail(), {
      req(recipes_library$detail())
      updateSelectInput(session = session,
                        inputId = "recipe_category",
                        choices =  recipes_library$detail() %>% 
                          distinct(recipe_category) %>% 
                          arrange(recipe_category) %>% 
                          pull(recipe_category))
    })
    observeEvent(input$recipe_category, {
      req(input$recipe_category)
      updateSelectInput(session = session,
                        inputId = "recipe_item",
                        choices = recipes_library$detail() %>% 
                          filter(recipe_category == input$recipe_category) %>% 
                          distinct(recipe_name) %>% 
                          arrange(recipe_name) %>% 
                          pull(recipe_name))
    })
    
    # Create Reactives ====
    r <- 
      reactiveValues(
        log = 
          tibble(date = as.Date(NA),
                 time = as.Date(NA),
                 type = as.character(NA),
                 category = as.character(NA),
                 item = as.character(NA),
                 recipe_total_weight = as.numeric(NA),
                 amount = as.numeric(NA),
                 measurement = as.character(NA),
                 amount_consumed = as.numeric(NA),
                 `Calories (kcal)` = as.numeric(NA),
                 `Protein (g)` = as.numeric(NA),
                 `Carbohydrates (g)` = as.numeric(NA),
                 `Total Fat (g)` = as.numeric(NA),
                 `Trans Fats (g)` = as.numeric(NA),
                 `Saturated Fats (g)` = as.numeric(NA),
                 `Sodium (mg)` = as.numeric(NA),
                 `Fiber (g)` = as.numeric(NA)) %>%
          filter(!is.na(item)))
    
    observeEvent(input$submit, {
      if(input$type == "Ingredient"){
        req(ingredients_library$table())
        r$log <- 
          bind_rows(isolate(r$log),
                    tibble(date = input$date,
                           time = input$time,
                           type = input$type,
                           category = input$ingredient_category,
                           item = input$ingredient_item,
                           recipe_total_weight = as.numeric(NA),
                           amount_consumed = input$amount,
                           measurement = input$measurement) %>% 
                      left_join(
                        ingredients_library$table() %>%
                          select(item = description,
                                 serving_size,
                                 `Calories (kcal)`:`Fiber (g)`),
                        by = "item"
                      ) %>%
                      mutate(across(
                        .cols = `Calories (kcal)`:`Fiber (g)`,
                        .fns = function(x) {
                          amount_consumed / serving_size * x
                        }
                      )) %>%
                      select(date:measurement,
                             amount_consumed,
                             `Calories (kcal)`:`Fiber (g)`))
      } else if(input$type == "Recipe"){
        req(recipes_library$summary())
        r$log <- 
          bind_rows(
            isolate(r$log),
            tibble(
              date = input$date,
              time = input$time,
              type = input$type,
              category = input$recipe_category,
              item = input$recipe_item,
              recipe_total_weight = input$recipe_totalWeight,
              amount_consumed = input$amount,
              measurement = input$measurement
            ) %>%
              left_join(
                recipes_library$summary() %>%
                  select(item = recipe_name,
                         `Calories (kcal)`:`Fiber (g)`),
                by = "item"
              ) %>%
              mutate(across(
                .cols = `Calories (kcal)`:`Fiber (g)`,
                .fns = function(x) {
                  amount_consumed / recipe_total_weight * x
                }
              )) %>%
              select(
                date:measurement,
                amount_consumed,
                `Calories (kcal)`:`Fiber (g)`
              )
          )
      }
    })
    
    # UI Outputs ====
    output$table <- DT::renderDT({ r$log })
    
    
  })
}
    
## To be copied in the UI
# mod_log_ui("log_ui_1")
    
## To be copied in the server
# mod_log_server("log_ui_1", ingredients_library, recipes_library)
