#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(httr)
library(xts)
library(tidyverse)
library(ggplot2)
library(plotly)
library(RColorBrewer)
library(glue)
library(shinyWidgets)
library(markdown)

source('homepage.R')
source('aboutus.R')
source('ui_main.R')
source('server_main.R')

# Run the application 
shinyApp(ui = ui, server = server)
