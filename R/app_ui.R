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
      fluidRow(
        column(3, h1("Nutrition Tracker"))
        ),
      tabsetPanel(
        tabPanel(title = "Log",
                 br(),
                 fluidRow(
                   column(2, radioButtons("log_view", label = "View Type", choices = c("Summary", "Add"), selected = "Summary", inline = TRUE)),
                   column(2, br(), mod_fileInput_ui("fileInput_ui_log")),
                   column(2, br(), mod_downloadButton_ui("downloadButton_ui_log"))
                 ),
                 conditionalPanel(condition = "input.log_view == 'Add'",
                                  mod_log_ui("log_ui_1")),
                 conditionalPanel(condition = "input.log_view == 'Summary'",
                                  sidebarLayout(
                                    sidebarPanel(
                                      width = 3,
                                      h2("Options"),
                                      selectInput("viz_type", 
                                                  label = "Visual", 
                                                  choices = c("Daily Caloric Intake", "Individual Meals"), 
                                                  selected = "Daily Caloric Intake"),
                                      hr(),
                                      h2("Inputs"),
                                      conditionalPanel(condition = "input.viz_type == 'Daily Caloric Intake'",
                                                       mod_viz_barchart_sidebar_ui("viz_barchart_sidebar_ui_1")),
                                      conditionalPanel(condition = "input.viz_type == 'Individual Meals'",
                                                       mod_viz_scatter_meal_sidebar_ui("viz_scatter_meal_sidebar_ui_1"))
                                      ),
                                    mainPanel(
                                      width = 9,
                                      conditionalPanel(condition = "input.viz_type == 'Daily Caloric Intake'",
                                                       h2("Daily Caloric Intake"),
                                                       mod_viz_barchart_ui("viz_barchart_ui_1")),
                                      conditionalPanel(condition = "input.viz_type == `Individual Meals`",
                                                       h2("Individual Meal Caloric Comparison"),
                                                       mod_viz_scatter_meal_ui("viz_scatter_meal_ui_1"))
                                      )
                                    )
                                  )
                 ),
        tabPanel(title = "Recipes",
                 br(),
                 fluidRow(
                   column(2, radioButtons("recipes_view", label = "View Type", choices = c("Library", "Add"), selected = "Library", inline = TRUE)),
                   column(2, br(), mod_fileInput_ui("fileInput_ui_recipes")),
                   column(2, br(), mod_downloadButton_ui("downloadButton_ui_recipes"))
                 ),
                 conditionalPanel(condition = "input.recipes_view == 'Add'",
                                  mod_recipe_add_ui("recipe_add_ui_1")),
                 conditionalPanel(condition = "input.recipes_view == 'Library'",
                                  mod_recipes_library_ui("recipes_library_ui_1"))),
        tabPanel(title = "Ingredients",
                 br(),
                 fluidRow(
                   column(2, radioButtons("ingredients_view", label = "View Type", choices = c("Library", "Add"),inline = TRUE)),
                   column(2, br(), mod_fileInput_ui("fileInput_ui_ingredients")),
                   column(2, br(), mod_downloadButton_ui("downloadButton_ui_ingredients"))
                 ),
                 conditionalPanel(condition = "input.ingredients_view == 'Add'",
                                  selectInput("upload_source", label = "Source", choices = c("Food Data Central", "Self-Upload"), selected = "Food Data Central"),
                                  conditionalPanel(condition = "input.upload_source == 'Food Data Central'",
                                                   sidebarLayout(
                                                     sidebarPanel(
                                                       width = 3,
                                                       h2("Lookup Parameters"),
                                                       mod_fdc_lookupParameters_ui("fdc_lookupParameters_ui_1")
                                                       ),
                                                     mainPanel(
                                                       width = 9,
                                                       h2("Results"),
                                                       mod_fdc_lookupTable_ui("fdc_lookupTable_ui_1")
                                                       )
                                                     )
                                                   ),
                                  conditionalPanel(condition = "input.upload_source == 'Self-Upload'",
                                                   h6("Please fill out the form below for each ingredient"),
                                                   mod_ing_selfUpload_ui("ing_selfUpload_ui_1"))),
                 conditionalPanel(condition = "input.ingredients_view == 'Library'",
                                  mod_ing_libraryTable_ui("ing_libraryTable_ui_1"))),
        tabPanel(title = "Test",
                 br(),
                 sidebarLayout(
                   sidebarPanel(
                     mod_recipeLookup_inputs_ui("recipeLookup_inputs_1")
                   ),
                   mainPanel(
                     mod_recipeLookup_table_ui("recipeLookup_table_1")
                     )
                   )
        )
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

