#' viz_scatter_meal 
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
viz_scatter_meal <- function(log, day_start, day_end, x_var, y_var){
  # Shape Data
   data <- 
     log %>% 
     filter(date %within% lubridate::interval(day_start, day_end)) %>% 
     mutate(Fats = `Total Fat (g)` * 9,
            Carbohydrates = `Carbohydrates (g)` * 4,
            Protein = `Protein (g)` * 4) %>% 
     select(type, 
            category, 
            item,
            date,
            Total = `Calories (kcal)`,
            Protein,
            Carbohydrates,
            Fats)
   
   # Axis Title ====
   xlabel <- 
     if(x_var == "Total") {
       "Total (kcal)"
     } else if(x_var == "Protein") {
       "Protein (kcal)"
     } else if(x_var == "Carbohydrates") {
       "Carbohydrates (kcal)"
     } else if(x_var == "Fats") {
       "Fats (kcal)"
     }
   
   ylabel <- 
     if(y_var == "Total") {
       "Total (kcal)"
     } else if(y_var == "Protein") {
       "Protein (kcal)"
     } else if(y_var == "Carbohydrates") {
       "Carbohydrates (kcal)"
     } else if(y_var == "Fats") {
       "Fats (kcal)"
     }
   
   max_val <- if(nrow(data) > 0){
     max(data %>% select(Total:Fats), na.rm = TRUE)
   } else {
     0
   }
   
   limits <- 
     if(max_val > 2000){
       c(0, plyr::round_any(max_val, accuracy = 1000, f = ceiling()))
     } else {
       c(0, 2000)
     }
   
   # Plot ====
   g <- 
     data %>% 
     select(date, 
            x = !!x_var,
            y = !!y_var) %>% 
     ggplot(aes(x = x, y = y)) + 
     geom_point(col = "blue", size = 4, alpha = 0.7) + 
     theme_classic() + 
     scale_x_continuous(limits = limits, labels = scales::comma) + 
     scale_y_continuous(limits = limits, labels = scales::comma) + 
     xlab(xlabel) + 
     ylab(ylabel) +
     geom_abline(intercept = 0, slope = 1, linetype = "dashed")
   
   # Return ====
   list(plot = g, data = data)
}


