#' Run the Shiny Application
#'
#' @param ... arguments to pass to golem_opts. 
#' See `?golem::get_golem_options` for more details.
#' @inheritParams shiny::shinyApp
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options 
#' @import config
#' @import httr
#' @import jsonlite
#' @import janitor
#' @import DT
#' @import stringr
#' @import tools
#' @import dplyr
#' @import forcats
#' @import purrr
#' @import tidyr
#' @import shinycssloaders
#' @import readr
#' @import shinyTime
#' @import readxl
#' @import openxlsx
#' @import ggplot2
#' @import lubridate
#' @import rvest
#' 
run_app <- function(
  onStart = NULL,
  options = list(), 
  enableBookmarking = NULL,
  uiPattern = "/",
  ...
) {
  with_golem_options(
    app = shinyApp(
      ui = app_ui,
      server = app_server,
      onStart = onStart,
      options = options, 
      enableBookmarking = enableBookmarking, 
      uiPattern = uiPattern
    ), 
    golem_opts = list(...)
  )
}
