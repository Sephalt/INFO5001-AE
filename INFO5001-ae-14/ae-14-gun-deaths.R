# gun-deaths.R
# 2024-10-29
# Examine the distribution of age of victims in gun_deaths

# load packages
library(tidyverse)
library(rcis)

# filter data for under 65
youth <- gun_deaths |>
  filter(age <= 65)

# number of individuals under 65 killed
nrow(gun_deaths) - nrow(youth)

# graph the distribution of youth
ggplot(data = youth, mapping = aes(x = age)) +
  geom_freqpoly(binwidth = 1)

# graph the distribution of youth, by race
youth |>
  mutate(race = fct_infreq(race) |> fct_rev()) |>
  ggplot(mapping = aes(y = race)) +
  geom_bar() +
  labs(y = "Victim race")
