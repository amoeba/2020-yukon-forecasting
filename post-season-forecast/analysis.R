library(dplyr)
library(ggplot2)
library(readr)

# calculate percentiles
# compare sites

# Big Eddy Set
beset <- read_csv("data/big_eddy_set.csv")

beset %>% mutate(ccpue = cumsum(cpue),
                 pccpue = ccpue / max(ccpue)) -> beset

beset %>% filter(pccpue >= 0.15) %>% select(day) %>% pull(day) %>% .[1]
beset %>% filter(pccpue >= 0.25) %>% select(day) %>% pull(day) %>% .[1]
beset %>% filter(pccpue >= 0.50) %>% select(day) %>% pull(day) %>% .[1]

# Big Eddy Drift
bedrift <- read_csv("data/bedrift.csv")

bedrift %>% mutate(ccpue = cumsum(cpue),
                 pccpue = ccpue / max(ccpue)) -> bedrift

bedrift %>% filter(pccpue >= 0.15) %>% select(day) %>% pull(day) %>% .[1]
bedrift %>% filter(pccpue >= 0.25) %>% select(day) %>% pull(day) %>% .[1]
bedrift %>% filter(pccpue >= 0.50) %>% select(day) %>% pull(day) %>% .[1]

# Pilot Station Sonar
sonar <- read_csv("data/pilotsonar.csv")

sonar %>% mutate(day = day -3,
                 ccount = cumsum(count),
                 pccount = ccount / max(ccount)) -> sonar

sonar %>% filter(pccount >= 0.15) %>% select(day) %>% pull(day) %>% .[1]
sonar %>% filter(pccount >= 0.25) %>% select(day) %>% pull(day) %>% .[1]
sonar %>% filter(pccount >= 0.50) %>% select(day) %>% pull(day) %>% .[1]
