# load packages
library(tidyverse)
library(rvest)
library(robotstxt)

# check that we can scrape data from the cornell review
paths_allowed("https://www.thecornellreview.org/")

# read the first page
page <- read_html("https://www.thecornellreview.org/")
# page <- read_html("data/cornell-review-raw.html") # use this if we break the website

# extract desired components
titles <- html_elements(x = page, css = "______") |>
  html_text2()

authors <- html_elements(x = page, css = "______") |>
  html_text2()

article_dates <- html_elements(x = page, css = "______") |>
  html_text2()

topics <- html_elements(x = page, css = "______") |>
  html_text2()

abstracts <- html_elements(x = page, css = "______") |>
  html_text2()

post_urls <- html_elements(x = page, css = "______") |>
  html_______(______)

# create a tibble with this data
## add code here

# clean up the data
## add code here

# save to disk
write_csv(x = review, file = "data/cornell-review.csv")
