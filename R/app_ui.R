# App UI ====
#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic 
    fluidPage(
      h1("Main Page"),
      br(),
      shiny::navbarPage("NavBar",
        shiny::tabPanel(title = "Summary",
                        mod_summary_main_ui("summary_main_ui_1")),
        shiny::tabPanel(title = "Recipes",
                        mod_recipes_main_ui("recipes_main_ui_1")),                
        shiny::tabPanel(title = "Ingredients",
                        mod_ingredients_main_ui("ingredients_main_ui_1"))
      )
    )
  )
}

# golem_add_external_resources() ====
#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#' 
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){
  
  add_resource_path(
    'www', app_sys('app/www')
  )
 
  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'Nutrition'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}

