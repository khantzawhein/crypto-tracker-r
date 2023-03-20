cmc_key <- "87a0a83c-792c-4d40-83b9-485a8007f144"
base_url <- "https://pro-api.coinmarketcap.com"

cmc_get <- function (endpoint, query = list()) {
  
  GET(
    paste0(base_url, endpoint),
    add_headers("X-CMC_PRO_API_KEY" = cmc_key),
    query = query
  )
}

