#' fdc_search 
#'
#' @description Search FoodData Central (FDC) API
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
fdc_search <- function(api_key, search_term, page_size = 1000, type = "Branded"){
  # Initial Search
  search_term_clean <- 
    search_term %>% 
    str_replace_all(" ", "%20")
  
  search_url_base <- 
    paste0("https://api.nal.usda.gov/fdc/v1/foods/search?query=",
           search_term_clean,
           "&api_key=",
           api_key,
           "&pageSize=",
           page_size) 
  
  if(type == "Branded"){
    data_raw <-
      search_url_base %>% 
      paste0("&dataType=Branded") %>% 
      httr::GET(url = .) %>% 
      content(as = "text") %>% 
      jsonlite::fromJSON() %>% 
      .$foods %>% 
      janitor::clean_names()
    
    ids <- 
      data_raw$fdc_id
    
    nutrition_data <- 
      pmap_df(.l = list(x = ids, 
                        y = data_raw$food_nutrients),
              .f = function(x, y){
                y %>%
                  mutate(fdc_id = x)
              }
      ) %>% 
      janitor::clean_names() %>% 
      left_join(data_raw %>% 
                  select(fdc_id:score),
                by = "fdc_id") %>% 
      as_tibble() %>% 
      mutate(across(.cols = everything(), .fns = function(x){na_if(x = x, y = "")}),
             published_date = ymd(published_date))
      
    
  } else if(type == "General"){
    data_raw <- 
      search_url_base %>% 
      paste0("&dataType=Foundation,SR%20Legacy") %>% 
      httr::GET(url = .) %>% 
      content(as = "text") %>% 
      jsonlite::fromJSON() %>% 
      .$foods %>% 
      janitor::clean_names()
    
    ids <- 
      data_raw$fdc_id
    
    nutrition_data <- 
      pmap_df(.l = list(x = ids, 
                        y = data_raw$food_nutrients),
              .f = function(x, y){
                y %>% 
                  mutate(fdc_id = x)
              }
      ) %>% 
      janitor::clean_names() %>% 
      left_join(data_raw %>% 
                  select(fdc_id:score),
                by = "fdc_id") %>% 
      as_tibble() %>% 
      mutate(across(.cols = everything(), .fns = function(x){na_if(x = x, y = "")}))
  }
    
  nutrition_data
}


