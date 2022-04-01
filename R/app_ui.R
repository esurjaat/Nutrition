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
    dashboardPage(
      dashboardHeader(
        title = "Nutrition Tracker"
      ),
      dashboardSidebar(
        sidebarMenu(
          menuItem(text = "About",
                   tabName = "about"),
          menuItem(text = "Log",
                   tabName = "log",
                   menuSubItem(text = "Load / Save",
                               tabName = "log_load_save"),
                   menuSubItem(text = "Summary",
                               tabName = "log_summary"),
                   menuSubItem(text = "Add",
                               tabName = "log_add")),
          menuItem(text = "Recipes",
                   tabName = "recipes",
                   menuSubItem(text = "Load / Save",
                               tabName = "recipes_load_save"),
                   menuSubItem(text = "Library",
                               tabName = "recipes_library"),
                   menuSubItem(text = "Add",
                               tabName = "recipes_add")),
          menuItem(text = "Ingredients",
                   tabName = "ingredients",
                   menuSubItem(text = "Load / Save",
                               tabName = "ingredients_load_save"),
                   menuSubItem(text = "Library",
                               tabName = "ingredients_library"),
                   menuSubItem(text = "Add",
                               tabName = "ingredients_add"))
        )
      ),
      dashboardBody(
        tabItems(
          ## Log > Load / Save ====
          tabItem(
            tabName = "log_load_save",
            box(
              title = "Download / Upload Progress",
              solidHeader = FALSE,
              status = "primary",
              column(width = 6, mod_fileInput_ui("fileInput_ui_log")),
              column(width = 6, mod_downloadButton_ui("downloadButton_ui_log"))
            )
          ),
          ## Log > Summary ====
          tabItem(
            tabName = "log_summary",
            fluidRow(
              box(
                title = "Visual",
                width = 12,
                solidHeader = FALSE,
                status = "primary",
                column(
                  width = 2,
                  selectInput(
                    "viz_type",
                    label = "Visual",
                    choices = c("Daily Caloric Intake", "Individual Meals"),
                    selected = "Daily Caloric Intake"
                  ),
                  hr(),
                  h2("Inputs"),
                  conditionalPanel(
                    condition = "input.viz_type == 'Daily Caloric Intake'",
                    mod_viz_barchart_sidebar_ui("viz_barchart_sidebar_ui_1")
                  ),
                  conditionalPanel(
                    condition = "input.viz_type == 'Individual Meals'",
                    mod_viz_scatter_meal_sidebar_ui("viz_scatter_meal_sidebar_ui_1")
                  )
                ),
                column(
                  width = 10,
                  conditionalPanel(
                    condition = "input.viz_type == 'Daily Caloric Intake'",
                    h2("Daily Caloric Intake"),
                    mod_viz_barchart_ui("viz_barchart_ui_1")
                  ),
                  conditionalPanel(
                    condition = "input.viz_type == `Individual Meals`",
                    h2("Individual Meal Caloric Comparison"),
                    mod_viz_scatter_meal_ui("viz_scatter_meal_ui_1")
                  )
                )
              )
            )
          ),
          ## Log > Add ====
          tabItem(tabName = "log_add",
                  fluidRow(
                    box(
                      title = "Add",
                      width = 12,
                      solidHeader = FALSE,
                      status = "primary",
                      mod_log_ui("log_ui_1")
                    ))
          ),
          ## Recipes > Load / Save ====
          tabItem(
            tabName = "recipes_load_save",
            box(
              title = "Download / Upload Progress",
              solidHeader = FALSE,
              status = "primary",
              column(width = 6, mod_fileInput_ui("fileInput_ui_recipes")),
              column(width = 6, mod_downloadButton_ui("downloadButton_ui_recipes"))
            )
          ),
          ## Recipes > Library ====
          tabItem(tabName = "recipes_library",
                  fluidRow(
                    box(
                      title = "Library",
                      width = 12,
                      solidHeader = FALSE,
                      status = "primary",
                      mod_recipes_library_ui("recipes_library_ui_1")
                    )
                  )),
          ## Recipes > Add ====
          tabItem(tabName = "recipes_add",
                  fluidRow(
                    box(
                      title = "Add",
                      width = 12,
                      solidHeader = FALSE,
                      status = "primary",
                      mod_recipe_add_ui("recipe_add_ui_1")
                    )
                  )),
          ## Ingredients > Load / Save ====
          tabItem(
            tabName = "ingredients_load_save",
            box(
              title = "Download / Upload Progress",
              solidHeader = FALSE,
              status = "primary",
              column(width = 6, mod_fileInput_ui("fileInput_ui_ingredients")),
              column(width = 6, mod_downloadButton_ui("downloadButton_ui_ingredients"))
            )
          ),
          ## Ingredients > Library ====
          tabItem(tabName = "ingredients_library",
                  fluidRow(
                    box(
                      title = "Library",
                      width = 12,
                      solidHeader = FALSE,
                      status = "primary",
                      mod_ing_libraryTable_ui("ing_libraryTable_ui_1")
                    )
                  )),
          ## Ingredients > Add ====
          tabItem(tabName = "ingredients_add",
                  fluidRow(
                    box(
                      title = "Add",
                      width = 12, 
                      solidHeader = FALSE,
                      status = "primary",
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
                                       mod_ing_selfUpload_ui("ing_selfUpload_ui_1"))
                    )
                  ))
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

