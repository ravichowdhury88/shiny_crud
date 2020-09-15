# Library in packages used in this application
library(shiny)
library(DT)
library(RSQLite)
library(DBI)
library(shinyjs)
library(shinycssloaders)
library(lubridate)
library(shinyFeedback)
library(dplyr)
library(dbplyr)


conn <- DBI::dbConnect(
  RSQLite::SQLite(),
  dbname = 'data/tradedf.sqlite3'
)

shiny::onStop(function() {
  dbDisconnect(conn)
})




# Turn off scientific notation
options(scipen = 999)

# Set spinner type (for loading)
options(spinner.type = 8)

# Create 'names_map' dataframe to convert variable names ('names') to clean
# column names ('display_names') in table (i.e. capitalized words, spaces, etc.)
names_map <- data.frame(
  names = c('stock', 'trade_type', 'contract_type', 'paid_price', 'strike_price', 'date_open', 'date_expiry', 'sold_price', 'contracts_buy',
            'contract_close', 'date_close', 'stop_loss', 'profit_loss'),
  display_names = c('Stock', 'Trade Type', 'Contract Type', 'Paid Price',
                    'Strike Price', 'Date Open', 'Expiry Date', 'Price Sold',
                    'Contracts Buy', 'Contracts Sold', 'Date Close', 'Stop Loss', 'Profit Loss'),
  stringsAsFactors = FALSE
)



