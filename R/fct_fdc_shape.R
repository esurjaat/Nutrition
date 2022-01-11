#' fdc_shape_search
#'
#' @param api_key API Key used to query the Food Data Central (FDC) database
#' @param search_term Phrase used to conduct lookup
#' @param data_type Item type. Branded - Pre-packaged items where values derived from nutrition fact labels. Measured - Food items that have the nutritional values collected and measured by USDA
#' @param page_size max items to return (default and max allowable is 10,000)
#'
#' @description A wrapper to query the FDC database using search terms.
#'
#' @return data frame with the list of matching items
#'
#' @noRd
#'
#'
fdc_shape_search <- function(api_key, search_term, data_type = "Branded", page_size = 10000){
  search_term_clean <- 
    search_term %>% 
    str_replace_all(" ", "%20")
  
  data_type_clean <- 
    if(data_type == "Branded"){
      "Branded"
    } else if(data_type == "Measured"){
      "Foundation,SR%20Legacy"
    }
  
  data_raw <- 
    fdc_read(
      api_key = api_key,
      endpoint = "search",
      parameter_name = c("query", "pageSize", "dataType"),
      parameter_value = c(search_term_clean, page_size, data_type_clean)
    ) %>% 
    .$foods %>% 
    as_tibble() %>% 
    janitor::clean_names() %>% 
    mutate(fdc_id = as.character(fdc_id))
  
  # Output
  if(data_type == "Branded"){
    data_raw %>% 
      select(fdc_id, 
             description,
             food_category,
             upc = gtin_upc,
             brand_name, 
             brand_owner,
             market_country)
  } else if(data_type == "Measured"){
    data_raw %>% 
      select(fdc_id,
             description,
             food_category, 
             data_type)
  }
}

#' fdc_shape_id
#'
#' @param api_key API Key used to query the Food Data Central (FDC) database 
#' @param fdc_ids FDC IDs to lookup
#'
#' @description A wrapper to query the FDC database using FDC ID numbers to get detailed information.
#'
#' @return data frame with item descriptors and nutritional values
#' @export
#'
#' @examples
fdc_shape_id <- function(api_key, fdc_ids) {
  # Define ====
  nutrients <- 
    tribble( ~"nutrient_id", ~"nutrient_name",
             "208", "Calories (kcal)",
             "203", "Protein (g)",
             "205", "Carbohydrates (g)",
             "204", "Total Fat (g)",
             "605", "Trans Fats (g)",
             "606", "Saturated Fats (g)",
             "307", "Sodium (mg)",
             "291", "Fiber (g)") %>% 
    mutate(nutrient_name = as_factor(nutrient_name))
  
  ids <-
    fdc_ids %>%
    paste(collapse = "%2C")
  
  data_raw <-
    fdc_read(
      api_key = api_key,
      endpoint = "foods",
      parameter_name = "fdcIds",
      parameter_value = fdc_ids
    ) %>%
    as_tibble() %>%
    janitor::clean_names() %>% 
    mutate(fdc_id = as.character(fdc_id))
  
  data_ids <- data_raw$fdc_id
  
  data_types <- data_raw$data_type
  
  # Dissect ====
  ## Nutrients ====
  data_nutrients <-
    pmap_df(
      .l = list(x = data_raw$food_nutrients, y = data_ids),
      .f = function(x, y) {
        tibble(
          nutrient_id = x$nutrient$number,
          nutrient_amount = x$amount
        ) %>%
          right_join(y = nutrients, by = "nutrient_id") %>% 
          mutate(fdc_id = y,
                 nutrient_amount = case_when(
                   is.na(nutrient_amount) ~ as.numeric(0),
                   TRUE ~ nutrient_amount
                 )) %>% 
          select(fdc_id, nutrient_name, nutrient_amount) %>% 
          arrange(nutrient_name)
      }
    ) %>%
    as_tibble()
  
  data_nutrients_wide <-
    data_nutrients %>%
    select(fdc_id, nutrient_name, nutrient_amount) %>%
    spread(key = nutrient_name, value = nutrient_amount)
  
  
  ## Food Type ====
  data_foodType <- {
    temp <-
      tibble(fdc_id = character(),
             food_category = character())
    
    if ("Branded" %in% data_raw$data_type) {
      temp <-
        temp %>%
        bind_rows(
          data_raw %>%
            filter(data_type == "Branded") %>% 
            select(fdc_id,
                   food_category = branded_food_category) 
        )
    }
    
    if (any(c("SR Legacy", "Foundation") %in% data_raw$data_type)) {
      temp <-
        temp %>%
        bind_rows(
          data_raw %>% 
            pull(food_category) %>%
            mutate(fdc_id = data_ids,
                   data_type = data_types) %>%
            filter(data_type == "SR Legacy"| data_type == "Foundation") %>% 
            select(fdc_id, food_category = description)
        )
      
      temp
    }
  }
  
  ## Descriptions ====
  data_description <- {
    temp <- 
      tibble(fdc_id = character(),
             description = character(),
             data_type = character(),
             food_class = character(),
             upc = character(),
             brand_name = character(),
             brand_owner = character())
    
    if ("Branded" %in% data_raw$data_type){
      temp <- 
        temp %>% 
        bind_rows(
          data_raw %>% 
            filter(data_type == "Branded") %>% 
            select(fdc_id, 
                   description,
                   data_type,
                   food_class,
                   upc = gtin_upc,
                   brand_name,
                   brand_owner)
        )
    }
    
    if (any(c("SR Legacy", "Foundation") %in% data_raw$data_type)){
      temp <- 
        temp %>% 
        bind_rows(
          data_raw %>% 
            filter(data_type == "SR Legacy"| data_type == "Foundation") %>% 
            select(fdc_id,
                   description,
                   data_type,
                   food_class) %>% 
            mutate(upc = as.character(NA),
                   brand_name = as.character(NA),
                   brand_owner = as.character(NA))
        )
    }
      
    temp
  }
  
  # Combine ====
  data <- 
    data_description %>% 
    left_join(data_foodType, by = "fdc_id") %>% 
    left_join(data_nutrients_wide, by = "fdc_id")
  
  # Output ====
  data
  
}


