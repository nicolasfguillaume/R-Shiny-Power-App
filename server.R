library(shiny)
library(ggplot2)
library(leaflet)


# Loading data (consommation)
bilan_elec_df = read.csv("./data/bilan-electrique-transpose.clean.csv", 
                         header = TRUE, sep=';', fileEncoding="UTF-8")  # read csv file 
bilan_elec_df$Date <- as.Date(bilan_elec_df$Date, "%Y-%m-%d")
bilan_elec_df$annee <- format(bilan_elec_df$Date, "%Y")


# Loading data (renewables)
prod_elec_df = read.csv("./data/parc-raccorde-par-region-vf.clean.csv", 
                        header = TRUE, sep=';', fileEncoding="UTF-8")  # read csv file 
prod_elec_df$Geo.Point.str <- sapply(prod_elec_df$Geo.Point, as.character)
prod_elec_df$Geo.Point.str <- strsplit(prod_elec_df$Geo.Point.str, ", ")
prod_elec_df$Geo.Point.lat <- sapply(prod_elec_df$Geo.Point.str, function(x) as.numeric(x[1]) + runif(1, -0.5, 0.5))
prod_elec_df$Geo.Point.lng <- sapply(prod_elec_df$Geo.Point.str, function(x) as.numeric(x[2]) + runif(1, -0.5, 0.5))

mapColor <- function(x){
  if (x == 'Photovoltaique') {res = 'green'}
  else if (x == 'Photovoltaique') {res = 'green'}
  else if (x == 'Eolien') {res = 'yellow'}
  else if (x == 'Hydraulique') {res = 'blue'}
  else if (x == 'Cogeneration') {res = 'red'}
  else if (x == 'Bio energie') {res = 'brown'}
  else {res = 'black'}
  return(res)
}
prod_elec_df$color <- sapply(prod_elec_df$Type.de.production, mapColor)



# Define server logic for random distribution application
shinyServer(function(input, output) {

  
  dataset1 <- reactive( subset(bilan_elec_df , annee == input$annee & Categorie.client %in% input$cat_client) )
  
  output$plot1 <- reactivePlot(function() {
    
                  p <- ggplot(aes(x= Date, y = Puissance.moyenne.journaliere), 
                              data = dataset1() ) +
                    geom_line(color = 'orange') + geom_smooth()
                  
                  print(p)
                  
                })
  
  
  dataset2 <- reactive( subset(prod_elec_df , Type.de.production %in% input$cat_source) )
  
  output$map <- renderLeaflet({
                    
                  leaflet(dataset2()) %>% addTiles() %>% 
                    setView(lng = 2.00, lat = 47.00, zoom = 5) %>%  # set centre
                    addCircleMarkers(lng = ~Geo.Point.lng, lat = ~Geo.Point.lat, 
                                     weight=3, radius=5, stroke=FALSE,
                                     popup = ~Type.de.production,
                                     color = ~color, fillOpacity = 1.0)
                  
              })
  
  
  output$plot2 <- reactivePlot(function() {
    
                p <- ggplot(data=dataset2(), aes(x=Region, y=Puissance.cumulee, fill=Type.de.production)) +
                  geom_bar(stat="identity", position=position_dodge()) +
                  labs(title = "Puissance cumulee", x="Region", y  = "MW") +
                  theme(axis.text.x=element_text(angle = 45, hjust = 1))
                
                print(p)
    
  })
  


  
})