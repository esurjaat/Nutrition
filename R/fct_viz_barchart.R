#' viz_barchart 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
viz_barchart <- function(log, type, week_start){
  # Data Check ====
  
  # Data Transformation ====
  d <- 
    log %>% 
    mutate(Fats = `Total Fat (g)` * 9,
           Carbohydrates = `Carbohydrates (g)` * 4,
           Protein = `Protein (g)` * 4) %>% 
    select(date, 
           Calories = `Calories (kcal)`,
           Fats,
           Carbohydrates,
           Protein) %>% 
    pivot_longer(cols = c(Calories, Fats, Carbohydrates, Protein),
                 names_to = "type",
                 values_to = "amount") %>% 
    mutate(id = paste(date, type, sep = "_"))
  
  
  # filters
  weekdays_frame <- 
    tibble(date = seq.Date(from = week_start,
                           to = week_start + 6,
                           by = "days") %>%
             rep(4) %>%
             sort(),
           type = rep(c("Calories", "Fats", "Carbohydrates", "Protein"),7)) %>% 
    mutate(type = factor(type, levels = c("Calories","Protein", "Carbohydrates", "Fats")),
           id = paste(date, type, sep = "_"))
  
  weekdays_frame_filtered <- 
    if(type == "Total Calories"){
      weekdays_frame %>% 
        filter(type == "Calories")
    } else if(type == "Macronutrients"){
      weekdays_frame %>% 
        filter(type != "Calories")
    }
    
  
  
  d_weekdays <- 
    weekdays_frame_filtered %>% 
    left_join(y = d %>% select(-c(date, type)), by = "id") %>% 
    mutate(amount = amount %>% replace_na(0))
  
  limits_y <- 
    if(max(d_weekdays$amount) > 3000){
      c(0, max(d_weekdays$amount) %>% plyr::round_any(accuracy = 1000, f = ceiling))
    } else {
      c(0, 3000)
    }
  
  # Plot ====
  g_bar <- 
    if(type == "Total Calories"){
      geom_bar(stat = "identity", position = "dodge", fill = "blue")
    } else if(type == "Macronutrients") {
      geom_bar(stat = "identity", position = "dodge", aes(group = type, fill = type))
    }
  
  g <- 
    d_weekdays %>% 
    ggplot(aes(x = date, 
               y = amount)) +
    g_bar + 
    scale_y_continuous(limits = limits_y, labels = scales::comma) + 
    scale_x_date(breaks = d_weekdays$date %>% unique(),
                 labels = d_weekdays$date %>% unique() %>% weekdays(abbreviate = TRUE)) + 
    xlab("Date") + 
    ylab("kilocalorie (kcal)") + 
    labs(fill = "Macronutrient Type") + 
    theme_classic()
  
  # Return ====
  g
  
}