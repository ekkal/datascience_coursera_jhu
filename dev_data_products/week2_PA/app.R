library(shiny)
library(shinyWidgets)
library(leaflet)
library(tidyverse)
library(lubridate)
library(RColorBrewer)

# UI design
ui <- fluidPage(

    titlePanel("Earth Quakes"),
    h4("Date Created: 03/24/2020"),

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

# server logic
server <- function(input, output, session) {

    # full data and color palette.
    data <- read_csv("world_earthquakes.csv")
    colorpal <- colorNumeric("YlOrRd", data$mag)

    # reactive data.
    filteredData <- reactive({
        data <- read_csv("world_earthquakes.csv") %>% filter(year(time) >= input$year_range[1] & year(time) <= input$year_range[2] & mag >= input$mag_range[1] & mag <= input$mag_range[2])
    })

    # draw and center view to north america
    output$map <- renderLeaflet({
        leaflet(data) %>% 
            setView(lng = -99, lat = 42, zoom = 3)  %>%
            addTiles() %>% 
            addCircles(
                lat = ~ latitude, 
                lng = ~ longitude, 
                color = "#777777",
                fillColor = ~colorpal(mag), 
                fillOpacity = 0.5,
                radius = ~ exp(sqrt(mag))*mag*1000, 
                weight = 1, 
                popup = ~as.character(sprintf("Magnitude: %s<br>Date: %s<br>Place: %s", mag, year(time), place)), 
                label = ~as.character(sprintf("Magnitude: %s, Date: %s, Place: %s", mag, year(time), place))
            )
    })

    # redraw based on controllers.
    observe({
        leafletProxy("map", data = filteredData()) %>%
            clearShapes() %>%
            addCircles(
                lat = ~ latitude, 
                lng = ~ longitude, 
                color = "#777777",
                fillColor = ~colorpal(mag), 
                fillOpacity = 0.5, 
                radius = ~ exp(sqrt(mag))*mag*1000, 
                weight = 1, 
                popup = ~as.character(sprintf("Magnitude: %s<br>Date: %s<br>Place: %s", mag, year(time), place)), 
                label = ~as.character(sprintf("Magnitude: %s, Date: %s, Place: %s", mag, year(time), place))
        )
    })
}

shinyApp(ui, server)
