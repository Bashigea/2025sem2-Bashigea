# DST 490, Day 12
# First look at interactive plots
# Packages needed: babynames, mdsr, plotly, dygraphs, DT

library(tidyverse)
library(mdsr)
library(babynames)

# Define the beatles
beatles_names <- c("John", "Paul", "George", "Ringo")

# Define what kids have the beatles names and are male. This will be a large data table
Beatles <- babynames |>
  filter(name %in% beatles_names & sex == "M")

# YOUR TURN - make a timeseries plot of the popularity of the Beatles names over time.  We will call this data frame beatles_plot
beatles_plot <-  # Insert code here



# Task 1: Interactive plot of prevalence of Beatles names:
library(plotly)
ggplotly(beatles_plot)


# Task 2: Making dygraphs
library(dygraphs)

Beatles |>
  select(year, name, n) |>
  pivot_wider(names_from = "name",values_from = "n") |>
  dygraph(main = "Popularity of Beatles names over time") |>
  dyRangeSelector(dateWindow = c("1940", "1980"))



# Task 3: Interactive data tables:
library(DT)
datatable(Beatles, options = list(pageLength = 2))


