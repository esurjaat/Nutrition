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
      h1("Nutrition Tracker"),
      tabsetPanel(
        tabPanel(title = "Log",
                 br(),
                 mod_log_ui("log_ui_1")),
        tabPanel(title = "Recipes",
                 br(),
                 radioButtons("recipes_view", label = "View Type", choices = c("Add", "Library")),
                 conditionalPanel(condition = "input.recipes_view == 'Add'",
                                  mod_recipe_add_ui("recipe_add_ui_1")),
                 conditionalPanel(condition = "input.recipes_view == 'Libray'",
                                  mod_recipes_library_ui("recipes_library_ui_1"))),
        tabPanel(title = "Ingredients",
                 br(),
                 radioButtons("ingredients_view", label = "View Type", choices = c("Add", "Library")),
                 conditionalPanel(condition = "input.ingredients_view == 'Add'",
                                  selectInput("upload_source", label = "Source", choices = c("Food Data Central", "Self-Upload"), selected = "Food Data Central"),
                                  conditionalPanel(condition = "input.upload_source == 'Food Data Central'",
                                                   sidebarLayout(
                                                     sidebarPanel(mod_fdc_lookupParameters_ui("fdc_lookupParameters_ui_1")),
                                                     mainPanel(mod_fdc_lookupTable_ui("fdc_lookupTable_ui_1")))),
                                  conditionalPanel(condition = "input.upload_source == 'Self-Upload'",
                                                   mod_ing_selfUpload_ui("ing_selfUpload_ui_1"))),
                 conditionalPanel(condition = "input.ingredients_view == 'Library'",
                                  mod_ing_libraryTable_ui("ing_libraryTable_ui_1")))
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
    favicon(ext = 'png'),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'Nutrition'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}

