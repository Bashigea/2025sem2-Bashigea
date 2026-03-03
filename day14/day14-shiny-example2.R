# DST 490, Day 14
# dygraphs with shiny
# Packages needed: babynames, shiny, tidyverse, plotly

library(shiny)
library(tidyverse)
library(babynames)
library(dygraphs)



# Define the beatles
beatles_names <- c("John", "Paul", "George", "Ringo")

# Define what kids have the beatles names and are male. This will be a large data table
Beatles <- babynames |>
  filter(name %in% beatles_names & sex == "M")


ui <- fluidPage(

  # App title ----
  h3("Frequency of Beatles names over time"),


  sidebarLayout(
    sidebarPanel(
      # Input: Numeric input for years and checkbox for names ----
      numericInput(inputId = "startyear",
                   label = "Enter starting year",
                   value = 1960,
                   min = 1880,
                   max = 2014,
                   step = 1),   # Notice the comma

      numericInput(inputId = "endyear",
                   label = "Enter ending year",
                   value = 1970,
                   min = 1881,
                   max = 2014,
                   step = 1),

      checkboxGroupInput(inputId = 'names',
                         label = 'Names to display:',
                         choices = beatles_names)

    ),
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Chart  ----
      dygraphOutput("plot")    # Plot corresponds to the variable from the data table output below
      
    )
  )
)

server <- function(input, output) {

  ds <- reactive({
    Beatles |>
      filter(input$startyear <= year,
             year <= input$endyear,
             name %in% input$names)
  })


  output$plot <- renderDygraph({
    ds() |>
      select(year, name, n) |>
      pivot_wider(names_from = "name",values_from = "n") |>
      dygraph(main = "Popularity of Beatles names over time") |>
      dyRangeSelector(dateWindow = c("1940", "1980"))
  })

}

shinyApp(ui, server)
