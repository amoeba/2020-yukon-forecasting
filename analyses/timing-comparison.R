#' So far in 2020, the timing data have been funky. We have three lower-river
#' timing sources: Big Eddy Set, Big Eddy Drift, and Pilot Station sonar.
#'
#' How are these three sites comparing to one another? What initial spurred this
#' analysis was how suspect the Pilot Station numbers seemed. I did read that
#' ADF&G were having issues but I don't recall what those were or how much they
#' were thought to be affecting things.
#'
#' Let's take a look at how the three sites compare. I've offset Pilot Station
#' sonar's numbers by 3 days to accomodate for the usual lag time between fish
#' arriving at LYTF and Pilot Station sonar which is usually three days
#' (~100mi @ ~30mi/day).

library(readr)
library(ggplot2)
library(patchwork)

# load data series
beset <- read_csv("data/big_eddy_set.csv")
bedrift <- read_csv("data/bedrift.csv")
pilot <- read_csv("data/pilotsonar.csv")

# calc into percent-of-run and percent-of-cumulative-run
beset %>%
  mutate(site = "BE Set",
         ccpue = cumsum(cpue),
         prop = cpue / sum(cpue),
         cprop = ccpue / max(ccpue)) %>%
  select(site, day, prop, cprop) -> beset

bedrift %>%
  mutate(site = "BE Drift",
         ccpue = cumsum(cpue),
         prop = cpue / sum(cpue),
         cprop = ccpue / max(ccpue))  %>%
  select(site, day, prop, cprop) -> bedrift

pilot %>%
  mutate(site = "PSS 3dOffset",
         day = day - 3,
         ccount = cumsum(count),
         prop = count / sum(count),
         cprop = ccount / max(ccount))  %>%
  select(site, day, prop, cprop) -> pilot

# and combine into a single table
comb <- bind_rows(beset, bedrift, pilot)

# plot
theme_set(theme_bw())

por <- ggplot(comb, aes(day, prop, color = site)) +
  geom_line() +
  labs(title = "Percent of Run", y = "% of Run", x = "Day of June")

cpor <- ggplot(comb, aes(day, cprop, color = site)) +
  geom_line() +
  labs(title = "Cumulative Percent of Run", x = "Cumul. % of Run", y = "Day of June")

por / cpor
