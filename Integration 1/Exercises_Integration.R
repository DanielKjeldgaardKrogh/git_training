library(RPostgres)
library(DBI)
library(tidyverse)
library(httr2)
library(lubridate)

source("credentials.R")
source("psql_queries.R")

# EXERCISE 3
psql_manipulate(cred = cred_psql_docker,
                query_string = "CREATE SCHEMA intg1;")

psql_manipulate(cred = cred_psql_docker,
                query_string = 
                  " create table intg1.students(
                student_id serial primary key,
                student_name varchar(255),
                department_code int);")

psql_manipulate(cred = cred_psql_docker,
                query_string =                 
                "insert into intg1.students
                values
                (default, 'John', 1),
                (default, 'Mark', 2)
                ")
                
df <- data.frame(student_name = c("Heidi", "Lars"), department_code = c(1,3))

psql_append_df(cred = cred_psql_docker,
               schema_name = "intg1",
               tab_name = "students",
               df = df)

sqldata <- psql_select(cred = cred_psql_docker,
            query_string = "select * from intg1.students")

# Exercise 4 + 5
# I have subscribed to the API
# The API Key is: 'e2cfc6c104msh774c99e60458f59p15c0c3jsn117070aad870'

library(httr2)

# Here I simply finds the "symbol" for Tesla to later search for in hourly data
req <- request("https://alpha-vantage.p.rapidapi.com") %>%
  req_url_path("query") %>%
  req_url_query( "datatype" = "json",
                 "keywords" = "Tesla",
                 "function" = "SYMBOL_SEARCH") %>%
  req_headers('x-rapidapi-key' = 'e2cfc6c104msh774c99e60458f59p15c0c3jsn117070aad870', 
              'x-rapidapi-host' = 'alpha-vantage.p.rapidapi.com')
req

resp <- req %>%
  req_perform()

symbols <- resp %>%
  resp_body_json()

symbols$bestMatches[[1]]
symbols$bestMatches[[2]]

# We found symbol = TSLA

req2 <- request("https://alpha-vantage.p.rapidapi.com") %>%
  req_url_path("query") %>%
  req_url_query( "datatype" = "json",
                 "output_size" = "compact",
                 "interval" = "60min",
                 "function" = "TIME_SERIES_INTRADAY",
                 "symbol" = "TSLA" ) %>%
  req_headers('x-rapidapi-key' = 'e2cfc6c104msh774c99e60458f59p15c0c3jsn117070aad870', 
              'x-rapidapi-host' = 'alpha-vantage.p.rapidapi.com')

req2

resp2 <- req2 %>%
  req_perform()

resp2

series <- resp2 %>%
  resp_body_json()

series


# Exercise 6
timestamp <- lubridate::ymd_hms(names(series$`Time Series (60min)`), tz = "America/New_York")
timestamp <- format(timestamp, tz = "UTC")
df <- tibble(timestamp = timestamp, open = NA, high = NA, low = NA, close = NA, volume = NA)

for (i in 1:nrow(df)) {
  df[i,-1] <-as.data.frame(series$`Time Series (60min)`[[i]])
}

psql_manipulate(cred = cred_psql_docker,
                query_string = "create schema intg2;")

psql_manipulate(cred = cred_psql_docker,
                query_string = " create table )


OlsonNames()




