library(shiny)
library(shinyWidgets)
library(leaflet)

# UI design
ui <- fluidPage(

    titlePanel("Earth Quakes across the World!"),
    h4("Date Created: 03/29/2020"),

    sidebarLayout(
        sidebarPanel(
            # slider for year range.
            sliderInput("year_range", "Year Range:",
                        min = 2000, max = 2020,
                        value = c(2010,2020), sep = ""),

            # slider for magnitude range.
            sliderInput("mag_range", "Magnitude Range:",
                        min = 5, max = 10,
                        value = c(6,10), step = 0.5),
        ),

        mainPanel(
            # display map with default width and height.
            leafletOutput("map")
        )
    )
)
