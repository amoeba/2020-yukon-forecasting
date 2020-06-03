#' may_forecast.R
#'
#' 15/25/50 %tiles of timing using

library(dplyr)
library(ggplot2)
theme_set(theme_bw())
library(readr)
library(patchwork)

# Data loading/cleanup
######################
yuk <- read_csv("data/yukon.csv")
forecast_year <- 2020

# Plots
p_msstc <- ggplot(yuk, aes(msstc, mdj)) +
  geom_point(shape=1) +
  geom_vline(xintercept = yuk[which(yuk$year == forecast_year),"msstc"][[1]]) +
  labs(x = expression("MSSTC,"*~degree*"C"), y = "Median Run Timing (June)")

ggsave("pre-season-forecast/figures/mdj_against_msstc.png", width = 4, height = 4)

p_pice <- ggplot(yuk, aes(pice, mdj)) +
  geom_point(shape=1) +
  geom_vline(xintercept = yuk[which(yuk$year == forecast_year),"pice"][[1]]) +
  scale_x_continuous(limits = c(0, 1.0)) +
  labs(x = "PICE", y = "Median Run Timing (June)")

ggsave("pre-season-forecast/figures/mdj_against_pice.png", width = 4, height = 4)

p_amatc <- ggplot(yuk, aes(amatc, mdj)) +
  geom_point(shape=1) +
  geom_vline(xintercept = yuk[which(yuk$year == forecast_year),"amatc"][[1]]) +
  labs(x = expression("AMATC,"*~degree*"C"), y = "Median Run Timing (June)")

ggsave("pre-season-forecast/figures/mdj_against_amatc.png", width = 4, height = 4)

# Three panel plot
theme_set(theme_bw())
p_amatc + p_msstc + p_pice
ggsave("pre-season-forecast/figures/three_panel.png", width = 12, height = 4)

# Time series plot
theme_set(theme_classic() + theme(axis.title = element_blank(),
                                  panel.border = element_rect(size = 1, fill = NA),
                                  axis.line = element_blank(),
                                  title = element_text(size = 10)))

p1 <- ggplot(yuk, aes(year, amatc)) +
  geom_line() +
  geom_point(data = subset(yuk, year == forecast_year)) +
  geom_hline(yintercept = median(yuk[yuk$year < forecast_year, "amatc"][[1]])) +
  labs(title = "April Average Air Temperature (°C) at the Nome, AK airport") +
  theme(axis.title.x = element_blank())

p2 <- ggplot(yuk, aes(year, msstc)) +
  geom_line() +
  geom_point(data = subset(yuk, year == forecast_year)) +
  geom_hline(yintercept = median(yuk[yuk$year < forecast_year, "msstc"][[1]])) +
  labs(title = "May Average Sea Surface Temperature (°C), 62–64°N by 165–169°W") +
  theme(axis.title.x = element_blank())

p3 <- ggplot(yuk, aes(year, pice)) +
  geom_line() +
  geom_point(data = subset(yuk, year == forecast_year)) +
  geom_hline(yintercept = median(yuk[yuk$year < forecast_year, "pice"][[1]], na.rm = TRUE)) +
  scale_y_continuous(limits = c(0, 1)) +
  labs(title = "Spring Proportion of Ice Cover, 62–64°N by 165–169°W") +
  theme(axis.title.x = element_blank())


timeseries_3p <- p1 / p2 / p3

ggsave("pre-season-forecast/figures/timseries_3p.png", timeseries_3p, width = 6, height = 5)

# Models

# 15%
model_fifdj <- lm(fifdj ~ amatc + msstc + pice, data = subset(yuk, year < forecast_year))
summary(model_fifdj)
prediction_fifdj <- floor(predict(model_fifdj, newdata = yuk[yuk$year == forecast_year,]))
prediction_fifdj

# 25%
model_qdj <- lm(qdj ~ amatc + msstc + pice, data = subset(yuk, year < forecast_year))
summary(model_qdj)
prediction_qdj <- floor(predict(model_qdj, newdata = yuk[yuk$year == forecast_year,]))
prediction_qdj

# 50%
model_mdj <- lm(mdj ~ amatc + msstc + pice, data = subset(yuk, year < forecast_year))
summary(model_mdj)
prediction_mdj <- floor(predict(model_mdj, newdata = yuk[yuk$year == forecast_year,]))
prediction_mdj

predictions <- data.frame(percentile = c("fifdj", "qdj", "mdj"),
                          prediction = as.integer(c(prediction_fifdj,
                                         prediction_qdj,
                                         prediction_mdj)))
write_csv(predictions, path = "pre-season-forecast/output/predictions.csv")
