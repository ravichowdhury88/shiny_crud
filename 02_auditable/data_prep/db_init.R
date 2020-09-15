library(RSQLite)
library(DBI)
library(dplyr)

# Create a connection object with SQLite
conn <- dbConnect(
  RSQLite::SQLite(),
  '02_auditable/shiny_app/data/tradedf.sqlite3'
)

# Create a query to prepare the 'mtcars' table with additional 'uid', 'id',
# & the 4 created/modified columns
create_tradedf_query = "CREATE TABLE tradedf (
  uid                             TEXT PRIMARY KEY,
  id_                             TEXT,
  stock                           TEXT,
  trade_type                      TEXT,
  contract_type                   TEXT,
  paid_price                      REAL,
  strike_price                    REAL,
  date_open                       DATE,
  date_expiry                     DATE,
  sold_price                      REAL,
  contracts_buy                   INTEGER,
  contract_close                  INTEGER,
  date_close                      DATE,
  stop_loss                       REAL,
  profit_loss                     REAL,
  created_at                      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_by                      TEXT,
  modified_at                     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modified_by                     TEXT,
  is_deleted                      BOOLEAN DEFAULT 0
)"

# dbExecute() executes a SQL statement with a connection object
# Drop the table if it already exists
dbExecute(conn, "DROP TABLE IF EXISTS tradedf")
# Execute the query created above
dbExecute(conn, create_tradedf_query)

# Read in the RDS file created in 'data_prep.R'
dat <- readRDS("02_auditable/data_prep/prepped/tradedf.RDS")

# add uid column to the `dat` data frame.  This will be unique to each row.
dat$uid <- uuid::UUIDgenerate(n = nrow(dat))

# Create an id for each car.  When we make edits to a car we will insert an entire
# new row for the car.  We will use this id_ column to uniquly identify each car.
# To get the current data, we query for the most recently modified row for each
# unique id_.
dat$id_ <- uuid::UUIDgenerate(n = nrow(dat))

# reorder the columns so `uid` is 1st
dat <- dat %>%
  select(uid, id_, everything())

# Fill in the SQLite table with the values from the RDS file
DBI::dbWriteTable(
  conn,
  name = "tradedf",
  value = dat,
  overwrite = FALSE,
  append = TRUE
)

# List tables to confirm 'mtcars' table exists
dbListTables(conn)

# MUST disconnect from SQLite before continuing
dbDisconnect(conn)


