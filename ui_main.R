ui <- bootstrapPage(
  fluidPage(
    navbarPage(
      "Crypto Market Chart",
      tabPanel("Price Chart", homepage),
      tabPanel("About Us", aboutus)
    ),
    
  )
)