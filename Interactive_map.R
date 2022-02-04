
## load the necessary packages

library(ggplot2)
library(dplyr)
library(plotly)
library(rnaturalearth)
library(tidyverse)
library(readr)

## get state polygons for Canada

canada <- ne_states(country = "Canada", returnclass = "sf")

## get the real-time situations about COVID-19 for each province in Canada

map_data <- read_csv("https://opendata.arcgis.com/datasets/4007a7d2396a4966816628d3abc058c2_0.csv")


map_data$NAME <- map_data$NAME %>% str_replace_all(pattern = "Quebec", replacement = "Québec")

tidy_data <- map_data %>% rename(name = NAME) %>% filter(name!="Repatriated CDN") %>% select(name, Case_Total, Recovered, Deaths, Tests, ActiveCases, Hospitalized, ICU)

canada <- full_join(canada, tidy_data, by = "name")

## use plot_ly function to make an interactive map

fig <- plot_ly(canada, split = ~name, color = ~name,
               text = ~paste(name, "\n Total # of People Tested:", Tests,
                             "\n Total # of Cases:", Case_Total,
                             "\n Total Recovered:", Recovered,
                             "\n Total Deaths:", Deaths,
                             "\n Active Cases:", ActiveCases,
                             "\n Currently Hospitalized:", Hospitalized,
                             "\n Currently in ICU:", ICU),
               name = ~name,
               legendgroup = ~name,
               hoveron = "fills",
               hoverinfo = "text",
               showlegend = TRUE)

fig %>% layout(legend = list(title=list(text='<b> Province </b>')))

## use api_creat to post your plot to your plotly account

# api_create(fig, filename = "Interactive map for Canada")
