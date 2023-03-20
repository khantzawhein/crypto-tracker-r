source("api_clients/cmchttr.R")

get_current_quote_data <- function(crypto_id = c()) {
  crypto_quote_res <- cmc_get("/v2/cryptocurrency/quotes/latest", query = list(id = paste0(crypto_id, collapse = ",")))
  crypto_data <- content(crypto_quote_res)
  crypto_data_list <- data.frame(id = c(NA), price_usd = c(NA), percent_change_24hr = c(NA), volume_change_24hr = c(NA), symbol = c(NA))
  for (id in crypto_id) {
    current_symbol_data <-  crypto_data$data[[as.character(id)]]
    df.tmp = data.frame(id = c(NA), price_usd = c(NA), percent_change_24hr = c(NA), volume_change_24hr = c(NA), symbol = c(NA))
    df.tmp$id <- id
    df.tmp$price_usd <- current_symbol_data$quote$USD$price
    df.tmp$percent_change_24hr  <- current_symbol_data$quote$USD$percent_change_24h
    df.tmp$volume_change_24hr  <- current_symbol_data$quote$USD$volume_change_24h
    df.tmp$symbol <- current_symbol_data$symbol
    na.omit(df.tmp)
    row.names(df.tmp) <- c(current_symbol_data$symbol)
    crypto_data_list <- na.omit(rbind(crypto_data_list, df.tmp))
    
  }
  
  return(crypto_data_list)
}