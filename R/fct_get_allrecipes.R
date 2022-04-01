#' get_allrecipes 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
#' 
get_allrecipes <- function(url){
  temp_html <- 
    url %>% 
    read_html() 
  
  title <- 
    temp_html %>%
    html_nodes(xpath = "//main/div[1]/div[2]/div[1]/div[1]/div[1]/div/h1") %>% 
    html_text()
  
  ingredients <-
    tibble(
      ingredients =
        temp_html %>%
        html_nodes(xpath = "//fieldset/ul/li/label/span/span[contains(@class, 'ingredients-item-name')]") %>%
        html_text()
    ) %>% 
    mutate(
      ingredients_clean =
        ingredients %>% 
        str_replace_all("¼", ".25") %>% 
        str_replace_all("½", ".5") %>% 
        str_replace_all("⅔", ".666") %>% 
        
        str_replace(" ", ""),
      quantity = 
        case_when(
          ingredients_clean %>% str_detect("^[0-9\\.]") ~ 
            ingredients_clean %>% str_extract("(\\.)?[0-9]+(\\.)?([0-9]+)?") %>% as.numeric(),
          TRUE ~ as.numeric(NA)
        ),
      ingredients_clean2 = ingredients_clean %>% str_replace("^(([0-9]+)?(\\.)?([0-9]+)?( ))", ""),
      measurement = 
        case_when(
          is.na(quantity) ~ as.character(NA),
          ingredients_clean2 %>% str_detect("(cup)|(tablespoon(s)?)|(teaspoon(s)?)|(pound)") ~
            ingredients_clean2 %>% str_extract("(cup)|(tablespoon(s)?)|(teaspoon(s)?)|(pound)"),
          TRUE ~ "Units"
          ),
      item = 
        case_when(
          is.na(measurement) ~ ingredients_clean2,
          TRUE ~ ingredients_clean2 %>% str_replace(paste0(measurement, " "), "")
        ),
      measurement = measurement %>% str_replace("s$", ""),
      recipe_name = title
    ) %>% 
    select(recipe_name, ingredient = ingredients, quantity, measurement, item)
  
  ingredients

}