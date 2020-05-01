## WIP
## Quantile plot

# Quantiles
bins_mdj <- yuk %>%
  filter(yr < 2020) %>%
  select(mdj) %>% pull() %>%
  quantile(c(1/3, 2/3))

bins_amatc <- yuk %>%
  filter(yr < 2020) %>%
  select(amatc) %>% pull() %>%
  quantile(c(1/3, 2/3))

# Plot
ggplot(yuk, aes(amatc, mdj)) +
  geom_point(shape = 1) +
  geom_vline(xintercept = as.numeric(yuk[which(yuk$year == yr), "amatc"]), color = "red") +
  geom_hline(yintercept = bins) +
  geom_vline(xintercept = bins_amatc) +
  labs(x = expression("April Average Air Temp.,"*~degree*"C"), y = "Median Run Timing (Day of June)") +
  theme_bw()
