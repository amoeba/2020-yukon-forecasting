#' parameter_importance.R
#' 
#' How much weight does each parameter have in shifting the forecast one way or
#' another? I didn't have an a good idea of a formal way to do this so I devised
#' a method on my own.
#' 
#' Since each parameter is on its own scale, comparing the estimates directly
#' wouldn't be a fair comparison because, year-to-year, the variables change on 
#' different scales. To get at a fair comparison I scaled each estimate by the 
#' range and CV of the data for that variable. Does this make sense? I don't
#' know.

library(broom)
library(dplyr)
library(readr)

yuk <- read_csv("data/yukon.csv")
forecast_year <- 2018

model_mdj <- lm(mdj ~ amatc + msstc + pice, data = subset(yuk, year < forecast_year))
mdj_summary <- tidy(summary(model_mdj)) %>% filter(term != "(Intercept)")
historical_data <- yuk %>% filter(year < forecast_year)

ranges <- historical_data %>% 
  summarize(amatc = max(amatc) - min(amatc),
            msstc = max(msstc) - min(msstc),
            pice = max(pice, na.rm = TRUE) - min(pice, na.rm = TRUE))

cvs <- historical_data %>% 
  summarize(amatc = sd(amatc) / mean(amatc),
            msstc = sd(msstc) / mean(msstc),
            pice = sd(pice, na.rm = TRUE) / mean(pice, na.rm = TRUE))


mdj_summary$estimate / t(ranges)
mdj_summary$estimate / t(cvs)

#' I think scaling by CV makes a little more sense but I'm not sure why. Either
#' way, I see that PICE has an order of magnitude higher weight using this 
#' method.