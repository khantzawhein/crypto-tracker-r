

homepage <- div(
  # titlePanel("Crypto Price Chart"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(sidebarPanel(
    selectizeInput("crypto", label = "Select a crypto:", choices = NULL),
    
    actionButton("addToList", "Add to list", class = "btn-success"),
    actionButton("addTopHundred", "Add top 100 to list", class = "btn-success", style = "margin-top: 2px"),
    actionButton("clearBtn", "Clear", class = "btn-danger", style = "margin-top: 2px"),
  ),
  
  # Show a plot of the generated distribution
  mainPanel(
    textOutput("priceTextOutput"),
    plotlyOutput("percentChangeChartOutput"),
    plotlyOutput("volumeChangeChartOutput"),
    DT::DTOutput('cryptoListTable')
    )
  )
)

