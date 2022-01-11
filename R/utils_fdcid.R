#' fdcget
#'
#' @description To build an API Query for the Food Data Central (FDC) and return useful elements
#'
#' @param api_key The API Key used to access the FDC database
#' 
#' @param endpoint 
#' 
#' @param parameter_name 
#' 
#' @param parameter_value 
#'
#' @return A list of useful API elements
#'
#' @noRd
fdc_GET <- function(api_key, endpoint, parameter_name, parameter_value){
  # Define ====
  url_base <- "https://api.nal.usda.gov/fdc/v1/"
  url_endpoint_searchTerm <- "query"
  url_parameters_searchTerm <- c(data_type = "dataType", page_size = "pageSize", page_number = "pageNumber", sort_by = "sortBy", sort_order = "sortOrder", brand_owner = "brandOwner")
  url_endpoint_fdcId <- "foods"
  url_parameters_fdcId <- c(format = "format", nutrients = "nutrients")
  
  # Combine ====
  get_request <- 
    paste0(url_base,
           "/",
           endpoint,
           "?",
           "api_key=",
           api_key,
           paste0("&", parameter_name, "=", parameter_value, collapse = ""))
  
  # Output ====
  list(get_request = get_request,
       url_base = url_base,
       url_endpoint_searchTerm = url_endpoint_searchTerm,
       url_parameters_searchTerm = url_parameters_searchTerm,
       url_endpoint_fdcId = url_endpoint_fdcId,
       url_parameters_fdcId = url_parameters_fdcId)
  
}
