#' logistic_curve.R
#'
#' Generate the logistic curve for the website using the predicted percentiles
#' from may_forecast.R

library(ggplot2)
library(readr)

# Read in predictions, generated from models.R
predictions <- read_csv("early-forecast/output/predictions.csv")

# Define a logistic curve function
logi_fun <- function(x, mu, s) { 1 / (1 + exp(-((x - mu)/s))) }

# Pulled from fit_logistics.xlsx. R optim is just not happy (see: bad)
mu <- 19.0072489
s <- 4.589002334

xrange <- -10:50
cpue <- data.frame(day = xrange,
                   date = as.Date(xrange, format = "%j", origin = as.Date("2016-05-31")),
                   pccpue = 100 * logi_fun(xrange, mu, s))

# Write out
write_csv(cpue, path = "early-forecast/output/logistic_curve.csv")

predictions$percent <- c(15, 25, 50)
predictions$label <- paste0(c(15, 25, 50), "%")
predictions$date <- as.Date(predictions$prediction, format = "%j", origin = as.Date("2016-05-31"))

ggplot() +
  geom_bar(data = predictions, aes(date, percent), stat = "identity", fill = NA, color = "black") +
  geom_text(data = predictions, aes(date, percent, label = label), vjust = -1, size = 3) +
  geom_line(data = cpue, aes(date, pccpue)) +
  labs(x = "Date", y = "Cumulative % CPUE") +
  theme_bw()

ggsave("early-forecast/figures/logistic_curve.png", width = 6, height = 3)
