source("api_clients/cmchttr.R")

load_crypto_map <- function() {
  if (!file.exists("map.cache")) {
    crypto_map <- cmc_get("/v1/cryptocurrency/map", query = list(sort = "cmc_rank"))
    
    map_data <- content(crypto_map)[["data"]]
    df.map <- data.frame(matrix(ncol = 2, nrow = 0))
    colnames(df.map) <- c("id", "symbol")
    for (i in map_data) {
      df.map[nrow(df.map) + 1,] <- c(i$id, i$symbol)
    }
    
    write.csv(df.map, file = "map.cache", row.names = FALSE)
  }
  
  return(read.csv("map.cache"))
}