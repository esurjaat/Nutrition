#' titler
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd
titler <- function(data_frame){
  colnames(data_frame) <- 
    data_frame %>% 
    colnames() %>% 
    stringr::str_replace_all("_", " ") %>% 
    tools::toTitleCase()
  
  data_frame
}