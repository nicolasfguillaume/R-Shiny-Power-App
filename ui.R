library(shiny)
library(shinydashboard)
library(leaflet)
#install.packages("shinydashboard")


header <- dashboardHeader(title = "Dashboard")

sidebar <- dashboardSidebar(
                  sidebarMenu(
                    menuItem("Consommation electrique", tabName = "consommation", icon = icon("dashboard")),
                    menuItem("Production electrique", tabName = "production", icon = icon("th")),
                    menuItem("Source code", icon = icon("file-code-o"), 
                             href = "http://github.com/rstudio/shinydashboard/"),
                    menuItem("Nicolas Guillaume", icon = icon("file-code-o"), 
                             href = "http://www.nicolasguillaume.com/")
                  )
)

body <- dashboardBody(
                      tabItems(
                        # First tab content
                        tabItem(tabName = "consommation",
                                
                                h2("Consommation electrique par categorie de clients - France"),
                                
                                plotOutput("plot1"),
                                
                                hr(),
                                
                                fluidRow(

                                          box(
                                            title = "Parametres",
                                            radioButtons("cat_client", "Categorie de clients :",
                                                             c("Residentiels" = "Residentiels",
                                                               "Entreprises" = "Entreprises",
                                                               "PME / PMI" = "PME / PMI",
                                                               "Professionnels" = "Professionnels"),
                                                             selected="Residentiels"),
                                            sliderInput("annee", "Annee :", 2012, 2016, 2014)
                                          )

                                ),
                                
                                h4("Source des donnees :  https://erdf.opendatasoft.com/explore/dataset/bilan-electrique-transpose/")
                                
                        ),
                        
                        # Second tab content
                        tabItem(tabName = "production",
                                
                                h2("Production electrique par source - France"),
                                
                                fluidRow(
                                
                                        box(width = 12, leafletOutput("map"))
                                        
                                        ),
                                
                                hr(),
                                
                                fluidRow(

                                          box(
                                            title = "Parametres",
                                            checkboxGroupInput("cat_source", "Unite de production :",
                                                               c("Photovoltaique" = "Photovoltaique",
                                                                 "Eolien" = "Eolien",
                                                                 "Hydraulique" = "Hydraulique",
                                                                 "Cogeneration" = "Cogeneration",
                                                                 "Bio energie" = "Bio energie",
                                                                 "Autres" = "Autres"),
                                                               selected=c("Photovoltaique","Eolien"))
                                          ),
                                          
                                          box(plotOutput("plot2")),
                                          
                                h4("Source des donnees : https://erdf.opendatasoft.com/explore/dataset/parc-raccorde-par-region-vf/")
                                  
                                )
                        )
                      )
)


shinyUI(
  dashboardPage(header, sidebar, body)
  )

