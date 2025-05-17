# load packages
library(tidyverse)
library(rvest)
library(robotstxt)

# check that we can scrape data from the cornell review
paths_allowed("https://www.thecornellreview.org/")

# read the first page
page <- read_html("https://www.thecornellreview.org/")

# extract desired components
titles <- html_elements(x = page, css = "#main .read-title a") |>
  html_text2()

authors <- html_elements(x = page, css = "#main .byline a") |>
  html_text2()

article_dates <- html_elements(x = page, css = "#main .posts-date") |>
  html_text2()

topics <- html_elements(x = page, css = "#main .cat-links") |>
  html_text2()

abstracts <- html_elements(x = page, css = ".post-description") |>
  html_text2()

post_urls <- html_elements(x = page, css = ".aft-readmore") |>
  html_attr(name = "href")

# create a tibble with this data
review_raw <- tibble(
  title = titles,
  author = authors,
  date = article_dates,
  topic = topics,
  description = abstracts,
  url = post_urls
)

# clean up the data
review <- review_raw |>
  mutate(
    date = mdy(date),
    description = str_remove(string = description, pattern = "\nRead More")
  )

######## write a for loop to scrape the first 10 pages
scrape_results <- vector(mode = "list", length = 10)

for(page_num in 1:10) {
  # print a message to keep track of where we are in the iteration
  message(str_glue("Scraping page {page_num}"))

  # pause for a couple of seconds to prevent rapid HTTP requests
  Sys.sleep(2)

  # create the url to scrape
  # hint: str_glue() could be very useful
  # example format: https://www.thecornellreview.org/page/1/
  url <- str_glue("https://www.thecornellreview.org/page/{page_num}/")


  # read the first page
  page <- read_html(x = url)


  # extract desired components
  titles <- html_elements(x = page,
                          css = "#main .read-title a") |>
    html_text2

  authors <- html_elements(x = page,
                           css = "#main .byline a") |>
    html_text2
  
  article_dates <- html_elements(x = page,
                                 css = "#main .#main .posts-date") |>
    html_text2
  
  topics <- html_elements(x = page,
                          css = "#main .cat-links") |>
    html_text2
  
  abstracts <- html_elements(x = page,
                             css = "#main .post-description") |>
    html_text2
  
  post_urls <- html_elements(x = page,
                             css = "#main .aft-readmore") |>
    html_attr(name = "href")

  
  # create a tibble with this data
  review_raw <- tibble(
    title = titles,
    author = authors,
    date = article_dates,
    topic = topics,
    description = abstracts,
    url = post_urls
  )
  

  # clean up the data
  review <- review_raw |>
    mutate(
        date = mdy(date),
        description = str_remove(string = description,
                                 pattern = "\nRead More")
    )

  # store in the scrape_results list object
  scrape_results[[pagenum]] <- review

}

# collapse list of data frames to a single data frame
scrape_df <- list_rbind(x = scrape_results)

######## write a function to scrape a single page and use a map() function
######## to iterate over the first ten pages
# convert to a function

scrape_review <- function(url){
  
  # add code here
  
  page <- read_html(x = url)
  
  titles <- html_elements(x = page, css = "#main .read-title a") |>
    html_text2()
  
  authors <- html_elements(x = page, css = "#main .byline a") |>
    html_text2()
  
  article_dates <- html_elements(x = page, css = "#main .posts-date") |>
    html_text2()
  
  topics <- html_elements(x = page, css = "#main .cat-links") |>
    html_text2()
  
  abstracts <- html_elements(x = page, css = ".post-description") |>
    html_text2()
  
  post_urls <- html_elements(x = page, css = ".aft-readmore") |>
    html_attr(name = "href")
  
  review_raw <- tibble(
    title = titles,
    author = authors,
    date = article_dates,
    topic = topics,
    description = abstracts,
    url = post_urls
  )
  
  review <- review_raw |>
    mutate(
      date = mdy(date),
      description = str_remove(string = description, pattern = "\nRead More")
    )
  
  return(review)
  
}

# test function
## page 1
scrape_review(url = "https://www.thecornellreview.org/page/1/")

## page 2
scrape_review(url = "https://www.thecornellreview.org/page/2/")

## page 3
scrape_review(url = "https://www.thecornellreview.org/page/3/")

# create a vector of URLs
page_nums <- 1:10
cr_urls <- str_glue("https://www.thecornellreview.org/page/{page_nums}/")
cr_urls

# map function over URLs
cr_reviews <- map(.x = cr_urls, .f = scrape_review, .progress = TRUE) |>
  bind_rows()

# write data
write_csv(x = cr_reviews, file = "data/cornell-review-all.csv")
