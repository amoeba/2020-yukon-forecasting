# Modeling
##########

library(readr)
library(dplyr)
library(ggplot2)

# Change this first
###############
yr <- 2020 # TODO: _Could_ be a function instead...

# Data loading/cleanup
######################
yuk <- read_csv("data/yukon.csv")

model <- lm(mdj ~ amatc, data = subset(yuk, year < yr))
summary(model)

predict(model, newdata =  yuk[yuk$year == yr,])

result <- data.frame()

for (y in (max(yuk$year) - 15):(max(yuk$year) - 1)) {
  model <- lm(mdj ~ amatc, data = subset(yuk, year < y))
  model_pred <- as.numeric(floor(predict(model, newdata =  yuk[yuk$year == y,"amatc"])))

  result <- rbind(result,
                  data.frame(year = y,
                             obs = as.numeric(yuk[yuk$year == y,"mdj"]),
                             pred = model_pred))
}

mean(abs(result$obs - result$pred))
sd(abs(result$obs - result$pred))
max(abs(result$obs - result$pred))
mean(result$obs - result$pred)

ggplot(yuk, aes(amatc, mdj)) +
  geom_point(shape = 1) +
  stat_smooth(method = "lm", color = "black") +
  labs(x = "Median Run Timing (June)", y = expression("AMATC,"*~degree*"C"))

# Predictions

model_fifdj <- lm(fifdj ~ amatc, data = subset(yuk, year < yr))
predict(model_fifdj, newdata =  yuk[yuk$year == yr,])

model_qdj <- lm(qdj ~ amatc, data = subset(yuk, year < yr))
predict(model_qdj, newdata =  yuk[yuk$year == yr,])

model_mdj <- lm(mdj ~ amatc, data = subset(yuk, year < yr))
predict(model_mdj, newdata =  yuk[yuk$year == yr,])

predictions_df <- data.frame(
  percentile = c("fifdj", "qdj", "mdj"),
  prediction = c(
    floor(predict(model_fifdj, newdata =  yuk[yuk$year == yr,])),
    floor(predict(model_qdj, newdata =  yuk[yuk$year == yr,])),
    floor(predict(model_mdj, newdata =  yuk[yuk$year == yr,]))
  ))

write_csv(predictions_df, "early-forecast/output/predictions.csv")
