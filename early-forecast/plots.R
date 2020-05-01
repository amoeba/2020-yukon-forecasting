#' early_forecast.R
#'
#' 15/25/50 %tiles of timing using just AMATC

library(dplyr)
library(ggplot2)
library(readr)
library(ggtext)
library(patchwork)

# Change this first
###############
yr <- 2020 # TODO: _Could_ be a function instead...

# Data loading/cleanup
######################
yuk <- read_csv("data/yukon.csv")

# Plots
##########

# Plot 1. Standard, simple MDJ vs AMATC plot
annotation <- data.frame(
  label = glue("2020 Value: ", {yuk %>% filter(year == yr) %>% select(amatc) %>% pull()}, "°C"),
  x = yuk %>% filter(year == yr) %>% select(amatc) %>% pull(),
  y = 30,
  hjust = "center"
)

mdj_v_amatc <- ggplot(yuk, aes(amatc, mdj)) +
  geom_point(shape = 1) +
  geom_vline(xintercept = as.numeric(yuk[which(yuk$year == yr), "amatc"]),
             color = "black") +
  geom_richtext(data = annotation, aes(x, y, label = label, hjust = hjust)) +
  labs(title = "Median Run Timing vs. Air Temperature",
       x = expression("April Average Air Temp.,"*~degree*"C")) +
  scale_y_continuous(breaks = c(10, 15, 20, 25, 30),
                     labels = c("June 10th", "June 15th", "June 20th", "June 25th", "June 30th")) +
  theme_bw() +
  theme(axis.title.y = element_blank())

ggsave("early-forecast/figures/mdj_against_amatc.png", mdj_v_amatc, width = 5, height = 4)


# Plot 2: Time series of AMATC
yuk <- yuk %>% mutate(shape = ifelse(year == yr, 19, 1))

amatc_over_time <- ggplot(yuk, aes(year, amatc)) +
  geom_point(shape = yuk$shape) +
  geom_line() +
  labs(title = expression("Average April Air Temperature Over Time,"*~degree*"C"),
       x = "Year") +
  theme_bw() +
  theme(axis.title.y = element_blank())

ggsave("early-forecast/figures/amatc_by_year.png", amatc_over_time, width = 5, height = 1.5)

# Plot 3: Combined
combined <- amatc_over_time / mdj_v_amatc +  plot_layout(heights = c(1, 3))

ggsave("early-forecast/figures/combined.png",combined, width = 5, height = 7.5)

