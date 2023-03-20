source("helpers/load_crypto_map.R")
source("helpers/load_crypto_quote.R")

crypto_map <- load_crypto_map()
crypto_select_data <- crypto_map$id
names(crypto_select_data) <- crypto_map$symbol



server <- function(input, output, session) {
  listOfCryptos <-
    data.frame(
      id = c(NA),
      price_usd = c(NA),
      percent_change_24hr = c(NA),
      volume_change_24hr = c(NA),
      symbol = c(NA)
    )
  current_price_data <- NA
  
  output$priceTextOutput <- renderText({
    if (input$crypto != "") {
      current_price_data <<- get_current_quote_data(list(input$crypto))
      paste0("Current price is ", current_price_data[current_price_data$id == input$crypto]$price_usd, "$")
    }
  })
  
  observeEvent(input$addTopHundred, {
    top_100_price_data <-
      get_current_quote_data(as.list(crypto_select_data[1:100]))
    listOfCryptos <<- top_100_price_data
    renderCryptoDT()
    renderCharts()
    
    show_toast(
      title = "Success",
      text = glue("Top 100 cryptos are added to list successfully!"),
      type = "success",
      position = "top-end"
    )
  })
  
  observeEvent(input$addToList, {
    if (is.data.frame(current_price_data)) {
      listOfCryptos <<- rbind(listOfCryptos, current_price_data)
      listOfCryptos <<- na.omit(unique(listOfCryptos))
      renderCryptoDT()
      renderCharts()
      
      show_toast(
        title = "Success",
        text = glue("Symbol {current_price_data$symbol} added successfully!"),
        type = "success",
        position = "top-end"
      )
    }
  })
  
  renderCryptoDT <- function() {
    output$cryptoListTable <- DT::renderDataTable({
      rename(
        listOfCryptos,
        crypto_id = id,
        "Price USD" = price_usd,
        "Percent Change 24hr" = percent_change_24hr,
        "Volume Change 24hr" = volume_change_24hr,
        Symbol = symbol
      ) %>% 
      mutate(
        "No." = row_number(),
        Action = glue('<button id="delete_btn" class="btn btn-danger" onclick="Shiny.onInputChange(\'delete_row\', \'{No.}\')">Delete</button>')
      ) %>% 
      relocate("No.", .before = "Price USD")
    }, editable = FALSE, escape = FALSE, options = list(columnDefs = list(list(visible = FALSE, targets = c(1, 0)))))
  }
  
  renderCharts <- function() {
    if (nrow(listOfCryptos) > 0 && !is.na(listOfCryptos[1,]$id)) {
      output$volumeChangeChartOutput <- renderPlotly({
        ggplotly(
          ggplot(
            listOfCryptos,
            aes(
              x = symbol,
              y = volume_change_24hr,
              fill = symbol
            )
          ) +
            xlab("Symbol") + ylab("Volume Change 24 Hrs") +
            geom_col() +
            theme_minimal() +
            theme(axis.text.x = element_blank()) +
            scale_fill_manual(values = colorRampPalette(brewer.pal(8, "Set3"))(100))
        )
        
      })
      output$percentChangeChartOutput <- renderPlotly({
        ggplotly(
          ggplot(
            listOfCryptos,
            aes(
              x = symbol,
              y = percent_change_24hr,
              fill = symbol
            )
          ) +
            xlab("Symbol") + ylab("Percent Change 24 Hrs") +
            geom_col() +
            theme_minimal() +
            theme(axis.text.x = element_blank()) +
            scale_fill_manual(values = colorRampPalette(brewer.pal(8, "Set2"))(nrow(listOfCryptos)))
        )
        
      })
    } else {
      output$percentChangeChartOutput <- NULL
      output$volumeChangeChartOutput <- NULL
    }
  }
  
  observeEvent(input$clearBtn, {
    listOfCryptos <<- data.frame(
      id = c(NA),
      price_usd = c(NA),
      percent_change_24hr = c(NA),
      volume_change_24hr = c(NA),
      symbol = c(NA)
    )
    renderCryptoDT()
    renderCharts()
    show_toast(
      title = "Success",
      text = glue("List cleared successfully!"),
      type = "success",
      position = "top-end"
    )
  })
  
  updateSelectizeInput(
    session,
    'crypto',
    choices = crypto_select_data,
    server = TRUE,
    options = list(maxOptions = 20)
  )
  
  observeEvent(input$delete_row, {
    deletedCrypto <- listOfCryptos %>% filter(row_number() == input$delete_row)
    listOfCryptos <<- listOfCryptos %>% filter(row_number() != c(input$delete_row))
    show_toast(
      title = "Success",
      text = glue("Symbol {deletedCrypto$symbol} deleted successfully!"),
      type = "success",
      position = "top-end"
    )
    renderCryptoDT()
    renderCharts()
  })
}
