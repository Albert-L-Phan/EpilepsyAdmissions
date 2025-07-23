library(DT)
library(tidyverse)
library(plotly)
library(sf)
library(readxl)
library(leafpop)
library(shiny)
library(leaflet)
library(fcaR)
library(hasseDiagram)
library(BiocManager)
options(repos = BiocManager::repositories())
library(tmaptools)
load('hosp_dist_matrix_copy.rda')
load('mydata_ICU_Neuro.rda')
load('mydata_emergency.rda')
load('mydata_ICU.rda')
load('mydata_neurology.rda')
load('mydata_neurosurgery.rda')
LGASz<-LGASz_emergency
sz3<-sz3_emergency
#sz3= subset(sz3, select = -c(Specialist100000,Nerve) )
sz3= subset(sz3, select = -c(Specialist100000) )
LGASz<-st_transform(LGASz,4326)

#LGASz$SzPublic<-round(LGASz$SzPublic,2)
LGASz$GP100000<-round(LGASz$GP100000,2)
#LGASz$Nerve<-round(LGASz$Nerve,2)
LGASz$SMR<-round(LGASz$SMR,2)


#sz3$SzPublic<-round(sz3$SzPublic,2)
sz3$GP100000<-round(sz3$GP100000,2)
#sz3$Nerve<-round(LGASz$Nerve,2)
sz3$SMR<-round(LGASz$SMR,2)



LGASz2_emergency$SMR<-round(LGASz2_emergency$SMR,2)
LGASz2_emergency$GP100000<-round(LGASz2_emergency$GP100000,2)
#LGASz2_emergency$Nerve<-round(LGASz2_emergency$Nerve,2)


LGASz2_ICU$SMR<-round(LGASz2_ICU$SMR,2)
LGASz2_ICU$GP100000<-round(LGASz2_ICU$GP100000,2)
#LGASz2_ICU$Nerve<-round(LGASz2_ICU$Nerve,2)

LGASz2_neurology$SMR<-round(LGASz2_neurology$SMR,2)
LGASz2_neurology$GP100000<-round(LGASz2_neurology$GP100000,2)
#LGASz2_neurology$Nerve<-round(LGASz2_neurology$Nerve,2)

LGASz2_neurosurgery$SMR<-round(LGASz2_neurosurgery$SMR,2)
LGASz2_neurosurgery$GP100000<-round(LGASz2_neurosurgery$GP100000,2)
#LGASz2_neurosurgery$Nerve<-round(LGASz2_neurosurgery$Nerve,2)


LGASz2_ICU_Neuro$SMR<-round(LGASz2_ICU_Neuro$SMR,2)
LGASz2_ICU_Neuro$GP100000<-round(LGASz2_ICU_Neuro$GP100000,2)
#LGASz2_ICU_Neuro$Nerve<-round(LGASz2_ICU_Neuro$Nerve,2)


# Define UI for app that draws a histogram ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Map of Seizure Admissions in Australia"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      #selectInput(inputId = "Hasse_LGA", choices=colnames(bipartite), label =  "Choose a Local Government Area For Hasse Diagram", selected='Stonnington..C.'),
      #checkboxGroupInput('states', 'States', c('ACT','NSW','NT','QLD','SA','TAS','VIC','WA'), selected = c('NSW', 'QLD', 'VIC', 'NT', 'ACT', 'SA', 'WA', 'TAS')),
      
      verbatimTextOutput("value"),
      h4("Instructions"),
      HTML(paste0("<b>","Seizure Admissions Map","</b>", "")),
      p("The tab 'Seizure Admissions Map' has a choropleth map that shows the number of seizure admissions for each Local Government Area (LGA) in Australia. Click on an LGA to find the number of seizure admissions for that region. The ‘States’ checkbox on the left hand side can be used to select which states are displayed on the map. The ‘Variable for Map’ buttons below can be used to select which variable should be plotted on the map. The graph below also shows information for each LGA, ordered by state and alphabetical order. This graph can also be changed using the ‘States’ checkbox and the ‘Variable for Map’ buttons to display different information. Hover over one of the dots to find information for an individual LGA."),
      HTML(paste0("<b>","Hospital Catchment Map","</b>", "")),
      p("The 'Hospital Catchment Map' tab shows the number of seizure admissions for each hospital catchment. Hospital catchments were calculated by assigning LGAs to their closest hospital. Click on a hospital catchment to find the number of seizure admissions for that region. The ‘Variable for Map’ buttons on the left hand side can be used to select which variable should be plotted on the map. Each hospital has different resources. For example, some hospitals may have emergency departments but not neurology units. The ‘Hospital Resources’ buttons on the land hand side can be used to select which hospitals to be displayed that have a certain resource."),
      HTML(paste0("<b>","Table","</b>", "")),
      p("The 'Table' tab has a table that shows the data for each LGA. "),
      HTML(paste0("<b>","Hasse Diagram","</b>", "")),
      
      p("The 'Hasse Diagram' tab shows the hierarchy of hospitals depending on the local government area of an address chosen. Patients with status epilepticus require specialised services, thus can only go to certain hospitals. To determine which hospitals a patient should go to, we can construct a hierarchy of hospitals based on which services a hospital provides, as well as where the hospital is. For example, if there are two hospitals nearby, with the first hospital only having an emergency department, while the second hospital has an emergency department as well as a neurology unit, then the second hospital would be higher on the hierarchy compared to the first. We can show these relationships between the hospitals using a Hasse Diagram."),
      
      p("To find the hospital hierarchy for a LGA, type in an address, specifying the street address, suburb and state."),
      HTML(paste0("<b>","Github Page","</b>", "")),
      p(""),
      tags$a(href = "https://github.com/Albert-L-Phan/EpilepsyAdmissions",
             "Click Here to Access Github Page", target = "_blank")
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Seizure Admissions Map", 
                           fluidRow(column(width=4,
                                           checkboxGroupInput('states', 'States', c('ACT','NSW','NT','QLD','SA','TAS','VIC','WA'), selected = c('NSW', 'QLD', 'VIC', 'NT', 'ACT', 'SA', 'WA', 'TAS')),
                                           radioButtons('variable', 'Variable for Map', c('Standard Ratio'='SMR', 'General Practioners Per 100000'='GP100000'))),
                                    column(width=8,
                                           leafletOutput('map'))), plotlyOutput("graph")),
                  tabPanel("Hospital Catchments Map", 
                           fluidRow(column(width=4,
                                           radioButtons('variable1', 'Variable for Map', c('Standard Ratio'='SMR', 'General Practioners Per 100000'='GP100000')),
                                           radioButtons('hospresource', 'Hospital Resource', c("Emergency Department"='emergency', "Intensive Care Units"="ICU",'Neurology Department'='Neurology','Neurosurgery'='Neurosurgery','Neuro ICU'='NeuroICU'),selected='NeuroICU')),
                                    column(width=8,
                                           leafletOutput('map2')))),
                  tabPanel("Table", DT::dataTableOutput("table")),
                  tabPanel("Hasse Diagram",
                           fluidRow(column(width=4,
                                           textInput("Street", "Street Address",value='1205 Thompsons Rd'),
                                           textInput("Suburb", "Suburb",value="Cranbourne"),
                                           textInput("State", "State",value="Victoria")),
                                    column(width=6, offset=1,
                                           HTML(paste0("<b>","Local Government Area of Address")),
                                           verbatimTextOutput("lga"))),
                           imageOutput('Hasseplot'))
      )
    )
  )
)

server <- function(input, output, session) {
  
  output$table = DT::renderDataTable(sz3, colnames=c("State","Name", "Number of Seizure Admissions", "General Practioners Per 100000", "Population", "Standard Ratio", "Closest Emergency Department"), caption='Data obtained from PHIDU Torrens University',    
                                     extensions = c('Buttons','KeyTable','Responsive'),
                                     options = list(dom='Bfrtip', keys=T, 
                                                    button=c('copy', 'csv', 'excel', 'print', 'pdf')))
  
  output$graph <- renderPlotly({
    
    if (input$variable == 'SMR') {
      ggplotly(ggplot(na.omit(filter(sz3, sz3$State %in% input$states)), aes(x=Name, y=SMR, fill=State)) + geom_point() +facet_grid("State")+ylab("Standard Ratio")+xlab("LGA names") +scale_x_discrete(label="hide"))}
    else if (input$variable == 'GP100000') {
      ggplotly(ggplot(na.omit(filter(sz3, sz3$State %in% input$states)), aes(x=Name, y=GP100000, fill=State)) + geom_point() +facet_grid("State")+ylab("General Practioners Per 100000")+xlab("LGA names") +scale_x_discrete(label="hide"))}
    
  })
  
  #output$value <- renderText({input$states})
  output$lga <- renderText({
    address<- geocode_OSM(paste(input$Street,', ',input$Suburb,', ',input$State,', Australia'),as.sf=TRUE)
    address <- st_transform(address,4326)
    
    LGA_Residence<-LGASz[data.frame(st_intersects(address,LGASz))$col.id,]$LGA_Name})
  
  
  
  output$Hasseplot <- renderImage({
    
    address<- geocode_OSM(paste(input$Street,', ',input$Suburb,', ',input$State,', Australia'),as.sf=TRUE)
    address <- st_transform(address,4326)
    
    LGA_Residence<-LGASz[data.frame(st_intersects(address,LGASz))$col.id,]$LGA_Name
    
    
    
    fc <- FormalContext$new(hosp_dist_matrix_copy)
    fc <- fc$dual()
    fc$find_concepts()
    #fc$concepts$plot()
    
    
    
    numbers=c()
    Tag=LGASz[LGASz$LGA_Name==LGA_Residence,]$min_hospital
    for (i in 1:length(fc$concepts)){
      if(grepl(Tag, fc$concepts$sub(i)$get_intent()$to_latex(), fixed = TRUE)){numbers<-c(numbers,i)}
      
    }
    
    #fc$concepts$sublattice(numbers[1:length(numbers)-1])$plot()
    #numbers<-numbers[1:(length(numbers)-1)]
    numbers1=c()
    
    for (i in 1:length(fc$concepts)){
      if(fc$concepts$sub(numbers[1])$get_extent()  %<=% fc$concepts$sub(i)$get_extent()){numbers1<-c(numbers1,i)}
      
    }
    
    
    
    
    
    outfile <- tempfile(fileext='.jpg')
    jpeg(outfile, width = 1000, height = 1000,res=600)
    fc$concepts$sublattice(numbers1)$plot()
    dev.off()
    list(src = outfile,
         contentType = 'image/png',
         width = 1000,
         height = 1000,
         alt = "Error")
    
    
  }, deleteFile = TRUE)
  
  
  output$map <- renderLeaflet(
    
    {
      leaflet(LGASz) %>%
        setView(lng = 134, lat = -24, zoom = 3) %>%
        addTiles()
      
    }
  )
  
  
  observe({
    LGASz1<-filter(LGASz, LGASz$State %in% input$states)
    if (input$variable == 'SMR') {
      
      pal<-colorNumeric(
        palette=c("blue", "yellow", "red"),
        domain=LGASz1$SMR)
      leafletProxy("map") %>%
        clearShapes() %>%
        clearControls() %>%
        addPolygons(data = LGASz1,weight=.8, fillOpacity = .5,
                    fillColor = ~pal(SMR),     
                    popup = paste(
                      paste('<b>', 'State:', '</b>', LGASz1$State),
                      paste('<b>', 'LGA:', '</b>', LGASz1$LGA_Name),
                      paste('<b>', 'Closest Hospital:', '</b>', LGASz1$min_hospital),
                      paste('<b>', 'Standard Ratio:', '</b>', LGASz1$SMR),
                      paste('<b>', 'Number of Seizure Admissions:', '</b>', LGASz1$SzPublic_Number),
                      paste('<b>', 'GP per 100000:', '</b>', LGASz1$GP100000),
                      sep = '<br/>')) %>%
        addLegend(pal=pal,values=LGASz1$SMR,title="Standard Ratio")
      
    }
    
    
    else if (input$variable == 'GP100000') {
      pal<-colorNumeric(
        palette=c("blue", "yellow", "red"),
        domain=LGASz1$GP100000)
      leafletProxy("map") %>%
        clearShapes() %>%
        clearControls() %>%
        addPolygons(data = LGASz1,weight=.8,fillOpacity = .5,
                    fillColor = ~pal(GP100000),     
                    popup = paste(
                      paste('<b>', 'State:', '</b>', LGASz1$State),
                      paste('<b>', 'LGA:', '</b>', LGASz1$LGA_Name),
                      paste('<b>', 'Closest Hospital:', '</b>', LGASz1$min_hospital),
                      paste('<b>', 'Standard Ratio:', '</b>', LGASz1$SMR),
                      paste('<b>', 'Number of Seizure Admissions:', '</b>', LGASz1$SzPublic_Number),
                      paste('<b>', 'GP per 100000:', '</b>', LGASz1$GP100000),
                      sep = '<br/>')) %>%
        addLegend(pal=pal,values=LGASz1$GP100000,title="General Practioners Per 100000")}
    
    
    
    
  })
  
  
  output$map2 <- renderLeaflet(
    
    {
      pal<-colorNumeric(
        palette=c("blue", "yellow", "red"),
        domain=LGASz2_ICU_Neuro$SMR)
      leaflet("map2") %>%
        setView(lng = 134, lat = -24, zoom = 3) %>%
        addTiles()%>%
        addPolygons(data = LGASz2_ICU_Neuro,weight=.8, fillOpacity = .5,
                    fillColor = ~pal(SMR),
                    popup = paste(
                      paste('<b>', 'Closest Hospital:', '</b>', LGASz2_ICU_Neuro$min_hospital),
                      paste('<b>', 'Standard Ratio:', '</b>', LGASz2_ICU_Neuro$SMR),
                      paste('<b>', 'GP per 100000:', '</b>', LGASz2_ICU_Neuro$GP100000),
                      sep = '<br/>')) %>%
        addCircleMarkers(data= Hospitals_ICU_Neuro, lng=Hospitals_ICU_Neuro$Long, lat = Hospitals_ICU_Neuro$Lat, radius=1, popup=Hospitals_ICU_Neuro$Name) %>%
        addLegend(pal=pal,values=LGASz2_ICU_Neuro$SMR,title="Standard Ratio")
      
    }
  )
  
  observe({
    
    if (input$hospresource=='emergency'){
      a=LGASz2_emergency
      d=Hospitals_emergency
      f='emergency'}
    else if (input$hospresource=='ICU'){
      a=LGASz2_ICU
      d=Hospitals_ICU
      f='ICU'}
    else if (input$hospresource=='Neurology'){
      a=LGASz2_neurology
      d=Hospitals_neurology
      f='neurology'}
    else if (input$hospresource=='Neurosurgery'){
      a=LGASz2_neurosurgery
      d=Hospitals_neurosurgery
      f='neurosurgery'}
    else {
      a=LGASz2_ICU_Neuro
      d=Hospitals_ICU_Neuro
      f='ICU_Neuro'}
    
    
    
    if (input$variable1 == 'GP100000'){
      b='GP100000'
      c=~pal(GP100000)
      e="General Practioners Per 100000"}
    
    else {
      b='SMR'
      c=~pal(SMR)
      e="Standard Ratio"}
    
    
    pal<-colorNumeric(
      palette=c("blue", "yellow", "red"),
      domain=st_drop_geometry(a[b]))
    leafletProxy("map2") %>%
      clearShapes() %>%
      clearControls() %>%
      clearMarkers() %>%
      addPolygons(data = a,weight=.8, fillOpacity = .5,
                  fillColor = c,   
                  popup = paste(
                    paste('<b>', 'Closest Hospital:', '</b>', data.frame(st_drop_geometry(a))[,1]),
                    paste('<b>', 'Standard Ratio:', '</b>', a$SMR),
                    paste('<b>', 'GP per 100000:', '</b>', a$GP100000),
                    sep = '<br/>')) %>%
      addCircleMarkers(data= d, lng=d$Long, lat = d$Lat, radius=1, popup=d$Name) %>%
      addLegend(pal=pal,values=data.frame(st_drop_geometry(a[b]))[,1],title=e)})
  
  
  
  
  
}



shinyApp(ui = ui, server = server)

