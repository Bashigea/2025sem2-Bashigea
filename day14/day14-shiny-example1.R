# DST 490, Day 14
# Plotly with shiny
# Packages needed: babynames, shiny, tidyverse

# Define the setup for the code
library(shiny)
library(tidyverse)
library(babynames)
library(plotly)

# Define the beatles
beatles_names <- c("John", "Paul", "George", "Ringo")

# Define what kids have the beatles names and are male. This will be a large data table
Beatles <- babynames |>
  filter(name %in% beatles_names & sex == "M")


# Define UI for app that draws a histogram ----
ui <- fluidPage(

  # App title ----
  h3("Frequency of Beatles names over time"),

  # Sidebar layout with input and output definitions ----
  sidebarLayout(

    # Sidebar panel for inputs ----
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
      plotlyOutput("plot"),   # Plot corresponds to the variable from the data table output below.  Additional plots need a comma at the end to carry through to next line.
      plotlyOutput("plot2")
    )
  )
)



# Define server logic required to draw a timeseries plot ----
server <- function(input, output) {

  # Create dynamic data frame ds that filters based on user input
  ds <- reactive({
    Beatles |>
      filter(input$startyear <= year,
             year <= input$endyear,
             name %in% input$names)
  })




  output$plot <- renderPlotly({

    ggplotly(
      # Make the plot using ds as the input
      ggplot(data=ds(),  # Note how ds is a function ds() vs ds
             aes(x=year,y=n,group=name)
      ) +
        geom_line(linewidth=2)
    )

  })  # Close off renderPlot


  output$plot2 <- renderPlotly({

    plot_ly(ds(), x = ~year, y = ~n, color = ~name) |>
      add_lines()

  })  # Close off renderPlot




}

shinyApp(ui = ui, server = server)
