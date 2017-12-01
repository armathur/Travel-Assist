
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

library(SPARQL) # SPARQL querying package
library(ggplot2)
library(stringr)
library(stringi)
library(magrittr)
library(highcharter)




options(shiny.sanitize.errors = TRUE)

shinyServer(function(input, output) {
  
  v <- reactiveValues(doSubmit = FALSE)
  observeEvent(input$go, {
    # 0 will be coerced to FALSE
    # 1+ will be coerced to TRUE
    v$doSubmit <- input$go
  })
  observeEvent(input$tabset, {
    v$doSubmit <- FALSE
  })
  
  
  
  
  
  output$plotFlight <- renderHighchart({
    
    
    hotelCity =""
    
    if(input$city == "Las Vegas"){
      hotelCity = "Las_Vegas"
      replaceCity = "las vegas"
      
    }
    
    if(input$city == "Chicago"){
      hotelCity = "Chicago"
      replaceCity = "chicago"
      
    }
    
    if(input$city == "New York City"){
      hotelCity = "New_York_City"
      replaceCity = "new york city"
      
    }
    if(input$city == "San Francisco"){
      hotelCity = "San_Francisco"
      replaceCity = "san francisco"
      
    }
    
    
    df_air_for_chart <- read.csv("airlineReview3.csv")
    df_air_for_chart<- df_air_for_chart[which(df_air_for_chart$City==hotelCity),]
    
    
    hc<-highchart() %>% 
         hc_title(text = "Flight Rating vs Leg-room vs Cabin Crew") %>% 
         hc_add_series_scatter(mtcars$wt, mtcars$mpg, mtcars$drat, mtcars$hp)
    
    hc
    
  })

  
  
  
  
  output$plotRest <- renderHighchart({
    
    
    hotelCity =""
    
    if(input$city == "Las Vegas"){
      hotelCity = "Las_Vegas"
      replaceCity = "las vegas"
      
    }
    
    if(input$city == "Chicago"){
      hotelCity = "Chicago"
      replaceCity = "chicago"
      
    }
    
    if(input$city == "New York City"){
      hotelCity = "New_York_City"
      replaceCity = "new york city"
      
    }
    if(input$city == "San Francisco"){
      hotelCity = "San_Francisco"
      replaceCity = "san francisco"
      
    }
    
    
    df_rest_for_chart <- read.csv("restaurantData3.csv")
    df_rest_for_chart<- df_rest_for_chart[which(df_rest_for_chart$City==hotelCity),]
    
    
    hc<-highchart() %>% 
      hc_title(text = "Analysis of Restaurant Bar vs Rating") %>% 
      hc_add_series_scatter(df_rest_for_chart$Restaurant.Score, df_rest_for_chart$Bar)
    
    hc
    
  })
  
  
  output$plotHotel <- renderHighchart({
    
    
    hotelCity =""
    
    if(input$city == "Las Vegas"){
      hotelCity = "Las_Vegas"
      replaceCity = "las vegas"
      
    }
    
    if(input$city == "Chicago"){
      hotelCity = "Chicago"
      replaceCity = "chicago"
      
    }
    
    if(input$city == "New York City"){
      hotelCity = "New_York_City"
      replaceCity = "new york city"
      
    }
    if(input$city == "San Francisco"){
      hotelCity = "San_Francisco"
      replaceCity = "san francisco"
      
    }
    
    
    df_hotel_for_chart <- read.csv("hotelData3.csv")
    df_hotel_for_chart<- df_hotel_for_chart[which(df_hotel_for_chart$City==hotelCity),]
    
    
    hc<-highchart() %>% 
      hc_title(text = "Analysis of Hotel Rating vs Service vs Location") %>% 
      hc_add_series_scatter(df_hotel_for_chart$hotel, df_hotel_for_chart$location, df_hotel_for_chart$service, df_hotel_for_chart$location)
    
    
    hc
    
  })
  
  

  
  output$hotelTable <- renderDataTable({
    if (v$doSubmit == FALSE) return()
    #print(v$doSubmit)
    isolate({
    hotelCity =""
    
    if(input$city == "Las Vegas"){
      hotelCity = "Las_Vegas"
      replaceCity = "las vegas"
      
    }
    
    if(input$city == "Chicago"){
      hotelCity = "Chicago"
      replaceCity = "chicago"
      
    }
    
    if(input$city == "New York City"){
      hotelCity = "New_York_City"
      replaceCity = "new york city"
      
    }
    if(input$city == "San Francisco"){
      hotelCity = "San_Francisco"
      replaceCity = "san francisco"
      
    }
    
    
    endpoint <- 'http://localhost:3030/dbi-final/query'
    
    
    initial = print(input$hotel_variable)
    
    new  <- paste("?Service :",initial, sep = "")
    new2<- paste0("?",initial,"")
    new3<- paste(new,new2,"")
    new4<- paste0(new3,".","")
    addition = paste(new4, collapse = " ")
    
    
    new5 = paste(new2,collapse="+")
    #print(new5)
    #print(addition)
    
    query <- paste0(' PREFIX : <http://www.semanticweb.org/travelontologyfinal#>
                    
                    SELECT ?hotellabel ?url
                    WHERE {
                    ?hotel a :Hotel .
                    ?hotel :hotelUrl ?url .
                    ?hotel :label ?hotellabel .
                    ?hotel :inCity ?city .
                    ?city :label ?citylabel .
                    FILTER(?citylabel = "',hotelCity,'") .
                    ?hotel :provides ?Service .
                    ',addition,'
                    
                    }
                    ORDER BY DESC (',new5,')
                    LIMIT ',input$sliderLimit,'
                    
                    ')
    
    
    qd <- SPARQL(endpoint,query)
    df.rest <- qd$results
    #df.rest<- t(df.rest)
    rownames(df.rest) <- c()
    colnames(df.rest) <- c("Recommended Hotels","Url")
    
    if (replaceCity == "chicago"){
      country_city <- paste("Usa Illinois", input$city, sep = " ")
    }
    else if (replaceCity == "las vegas"){
      country_city <- paste("Usa Nevada", input$city ,sep = " ")
    }
    else{
      country_city <- paste("Usa", input$city, sep = " ")
    }
    #print(country_city)
    df.rest2 <- df.rest[,2]
    df.rest<-  as.data.frame(str_replace_all(df.rest[,1], "[^[:alnum:]]", " "))
    #print("removed underscore")
    #print(df.rest[,])
    df.rest[,] = str_replace_all(stri_trans_totitle(df.rest[,]), country_city, "")
    colnames(df.rest) <- c("Recommended Hotels")
    df.rest3 <- list()
    for(row in 1:nrow(df.rest)){
    df.rest3[[row]] <- paste0("<a href='",df.rest2[row],"' target='_blank'>",df.rest$"Recommended Hotels"[row],"</a>")}
    #print(df.rest$"Recommended Hotels"[row])}
    print(df.rest3)
    print(class(df.rest3))
    #df.rest3 <- as.data.frame(sapply(df.rest3, as.character))
    #print(typeof(df.rest3))
    #do.call(rbind,df.rest3)
    #print(df.rest3)
    #print(class(df.rest3))
    DF <- data.frame(do.call(rbind, as.list(df.rest3)))
    colnames(DF) <- c("Recommended Hotels")
    #print(class(DF))
    #print(DF)
    #print(length(df.rest3))
    DF
    })
  },escape = FALSE)
  #v$doSubmit <- FALSE
  
  output$airlineTable <- renderDataTable({
    #print(v$doSubmit)
    if (v$doSubmit == FALSE) return()
    isolate({
    airlineCity =""
    
    if(input$city == "Las Vegas"){
      airlineCity = "Las_Vegas"
      replaceCity = "las vegas"
      
    }
    
    if(input$city == "Chicago"){
      airlineCity = "Chicago"
      replaceCity = "chicago"
      
    }
    
    if(input$city == "New York City"){
      airlineCity = "New_York_City"
      replaceCity = "new york city"
      
    }
    if(input$city == "San Francisco"){
      airlineCity = "San_Francisco"
      replaceCity = "san francisco"
      
    }
    
    
    endpoint <- 'http://localhost:3030/dbi-final/query'
    
    
    initial = print(input$airline_variable)
    
    new  <- paste("?Service :",initial, sep = "")
    new2<- paste0("?",initial,"")
    new3<- paste(new,new2,"")
    new4<- paste0(new3,".","")
    addition = paste(new4, collapse = " ")
    
    
    new5 = paste(new2,collapse="+")
    #print(new5)
    #print(addition)
    
    query <- paste0(' PREFIX : <http://www.semanticweb.org/travelontologyfinal#>
                    
                    SELECT ?airlinelabel ?url
                    WHERE {
                    ?airline a :Airline .
                    ?airline :airlineUrl ?url .
                    ?airline :label ?airlinelabel .
                    ?airline :toDestinationCity ?city .
 	                  ?city :label ?citylabel .
                    FILTER(?citylabel = "',airlineCity,'") .
                    ?airline :airlineProvides ?Service .
                    ',addition,'
                    
                    }
                    ORDER BY DESC (',new5,')
                    LIMIT ',input$sliderLimit,'
                    
                    ')
    
    
    qd <- SPARQL(endpoint,query)
    df.rest <- qd$results
    
    #df.rest<- t(df.rest)
    rownames(df.rest) <- c()
    colnames(df.rest) <- c("Recommended Airlines")
    
    df.rest2 <- df.rest[,2]
    df.rest<-  as.data.frame(str_replace_all(df.rest[,1], "[^[:alnum:]]", " "))
    df.rest[,] = str_replace_all(stri_trans_totitle(df.rest[,]), input$city, "")
    colnames(df.rest) <- c("Recommended Airlines")
    df.rest3 <- list()
    for(row in 1:nrow(df.rest)){
      df.rest3[[row]] <- paste0("<a href='",df.rest2[row],"' target='_blank'>",df.rest$"Recommended Airlines"[row],"</a>")}
      #print(df.rest$"Recommended Airlines"[row])}
    DF <- data.frame(do.call(rbind, as.list(df.rest3)))
    colnames(DF) <- c("Recommended Airlines")
    DF
    #df.rest
    })
  },escape = FALSE)
  
  
  
  
  
  
  
  
  
  
  output$restTable <- renderDataTable({
    if (v$doSubmit == FALSE) return()
    isolate({
    restCity =""
    
    if(input$city == "Las Vegas"){
      restCity = "Las_Vegas"
      
    }
    
    if(input$city == "Chicago"){
      restCity = "Chicago"
      
    }
    
    if(input$city == "New York City"){
      restCity = "New_York_City"
      
    }
    if(input$city == "San Francisco"){
      restCity = "San_Francisco"
      
    }
    
    
    endpoint <- 'http://localhost:3030/dbi-final/query'
    
    
    initial = print(input$rest_variable)
    
    new  <- paste("?Service :",initial, sep = "")
    new2<- paste0("?",initial,"")
    new3<- paste(new,new2,"")
    new4<- paste0(new3,".","")
    addition = paste(new4, collapse = " ")
    
    
    new5 = paste(new2,collapse="+")
    #print(new5)
    #print(addition)
    
    query <- paste0(' PREFIX : <http://www.semanticweb.org/travelontologyfinal#>
                    
                    SELECT ?restaurantlabel ?url
                    WHERE {
                    ?restaurant a :Restaurant .
                    ?restaurant :restaurantUrl ?url .
                    ?restaurant :label ?restaurantlabel .
                    ?restaurant :restInCity ?city .
                    ?city :label ?citylabel .
                    FILTER(?citylabel = "',restCity,'") .
                    ?restaurant :restProvides ?Service .
                    ',addition,'
                    
                    }
                    ORDER BY DESC (',new5,')
                    LIMIT ',input$sliderLimit,'
                    
                    ')
    
    
    
    
    qd <- SPARQL(endpoint,query)
    df.rest <- qd$results
    
    #df.rest<- t(df.rest)
    rownames(df.rest) <- c()
    colnames(df.rest) <- c("Recommended Restaurants")
    df.rest2 <- df.rest[,2]
    df.rest<-  as.data.frame(str_replace_all(df.rest[,1], "[^[:alnum:]]", " "))
    df.rest[,] = str_replace_all(stri_trans_totitle(df.rest[,]), input$city, "")
    colnames(df.rest) <- c("Recommended Restaurants")
    df.rest3 <- list()
    for(row in 1:nrow(df.rest)){
      df.rest3[[row]] <- paste0("<a href='",df.rest2[row],"' target='_blank'>",df.rest$"Recommended Restaurants"[row],"</a>")}
      #print(df.rest$"Recommended Restaurants"[row])}
    DF <- data.frame(do.call(rbind, as.list(df.rest3)))
    colnames(DF) <- c("Recommended Restaurants")
    DF
    #df.rest
    })
    
  },escape = FALSE)
  
})
