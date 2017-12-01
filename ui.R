
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(shinyBS)
library(DT)

library(shinydashboard)


ui <- dashboardPage(
  dashboardHeader(title = "Travel Assistant"),
  dashboardSidebar( tags$style(type="text/css",href = "bootstrap.css", 
                               ".shiny-output-error { visibility: hidden; }",
                               ".shiny-output-error:before { visibility: hidden; }"
  ),
  
  
  
  selectInput("city", "Choose a Destination:",
              c("",list(`East Coast` = c("Chicago", "New York City"),
                   `West Coast` = c("San Francisco", "Las Vegas")))),
  
  textInput("optionalPrefArea", "Preferred Area: (optional)" , value = "", width = NULL, placeholder = "Hangout place?"),
  sliderInput("sliderLimit","Result Limit:", min = 0, max = 10, value = 5),
  actionButton("go", "Submit")
  ),
  dashboardBody(
    # Boxes need to be put in a row (or column)
    tabsetPanel(type = "tabs",
                
                tabPanel("Hotel", 
                         
                         box(checkboxGroupInput("hotel_variable", "Select Features:",
                                                c(
                                                  "Room" = "roomScore",
                                                  "Staff Service" = "staffScore",
                                                  "Accessibility" = "locationScore",
                                                  "Has Wifi" = "internetScore",
                                                  "Breakfast" = "breakfastScore",
                                                  "Restaurant" = "restaurantScore"
                                              
                                                  
                                                ))),
                         
                         box(title = "Search Results", status = "primary", dataTableOutput("hotelTable"))
                         
                         
                         
                ),
                tabPanel("Airline" ,
                         box(checkboxGroupInput("airline_variable", "Select Features:",
                                                c(
                                                  "Provides WiFi" = "providesWifi",
                                                  "Serves Food" = "providesFood",
                                                  "Punctual" = "isPunctual",
                                                  "Comfort" = "isComfortable",
                                                  "Cabin Crew" = "providesCrew",
                                                  "Easy CheckIn" = "easyCheckinScore",
                                                  "In Flight Entertainment"= "entertains"
                                                ))),
                         
                         box(title = "Search Results", status = "primary", dataTableOutput("airlineTable"))
                         
                         
                         
                ),
                tabPanel("Restaurant", 
                         box(checkboxGroupInput("rest_variable", "Select Features:",
                                                c("Provides Alcohol" = "alcoholScore",
                                                  "Ambience" = "ambTouristyScore",
                                                  
                                                  "Delivery" = "delivScore",
                                                  
                                                  "Drive Through"=  "driveThruScore",
                                                  "Noise Level" = "noiseLvlScore"))),
                         
                         box(title = "Search Results", status = "primary", dataTableOutput("restTable"))
                         
                         
                         
                ),
                tabPanel("Analysis", 
                         
                         box(status="warning",highchartOutput("plotHotel")),
                         box(status="success",highchartOutput("plotRest"))
                        
                  
                         
                         
                         )
                
    )
  )
)
