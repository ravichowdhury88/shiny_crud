library(dplyr)
library(tidyr)
library(tibble)
library(readr)

# attach data frame from 'mtcars' dataset to global environment
trade_df <- read_csv("02_auditable/data_prep/prepped/trade_data.csv",
                     col_types = cols(date_open = col_date(format = "%m/%d/%Y"),
                                      date_expiry = col_date(format = "%m/%d/%Y"),
                                      sold_price = col_number(), contracts_buy = col_integer(),
                                      contract_close = col_integer(), date_close = col_date(format = "%m/%d/%Y"),
                                      stop_loss = col_double(), profit_loss = col_double()))

saveRDS(trade_df, file = '02_auditable/data_prep/prepped/tradedf.RDS')
