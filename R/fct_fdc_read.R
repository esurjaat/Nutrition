#' fdc_read 
#'
#' @description Read data from the Food Data Central (FDC) API. Search by FDC ID or search terms
#' 
#' @param api_key The API Key used to que y the FDC API.
#' @param endpoint 
#' @param parameter_name 
#' @param parameter_value 
#'
#' @return 
#'
#' @noRd
fdc_read <- function(api_key, endpoint, parameter_name, parameter_value){
  # Definitions ====
  get_request <- 
    fdc_GET(api_key = api_key, 
            endpoint = endpoint, 
            parameter_name = parameter_name, 
            parameter_value = parameter_value) %>% 
    .$get_request
  
  # Read Data ====
  data <- 
    get_request %>% 
    httr::GET(url = .) %>% 
    content(as = "text") %>% 
    jsonlite::fromJSON()
  
  # Output ====
  data
}