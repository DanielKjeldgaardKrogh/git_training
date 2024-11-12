library(httr2)

local_url <- example_url()

local_url

req <- request(local_url)
req %>%
  req_dry_run()

# Exercise 3


req1 <- request("https://planets-by-api-ninjas.p.rapidapi.com") %>%
  req_url_path("v1/planets") %>%
  req_url_query(name = "Venus") %>%
  req_headers('X-rapidapi-key' = 'e2cfc6c104msh774c99e60458f59p15c0c3jsn117070aad870',
              'x-rapidapi-host' =  'planets-by-api-ninjas.p.rapidapi.com')
req1

resp <- req1 %>%
  req_perform()
resp

resp %>%
  resp_body_json()

# Exercise 4

req_4a <- request("http://165.22.92.178:8080") %>%
  req_url_path("responses") %>%
  req_url_query(format = "json") %>%
  req_headers(authorization = "DM_DV_123#!")

resp_4a <- req_4a %>%
  req_perform()
resp_4a

resp_4a %>%
  resp_body_json()

req_4b <- request("http://165.22.92.178:8080") %>%
  req_url_path("responses") %>%
  req_url_query(format = "html") %>%
  req_headers(authorization = "DM_DV_123#!")

resp_4b <- req_4b %>%
  req_perform()
resp_4b

resp_4b %>%
  resp_body_html()

# Exercise 5

n <- 70
x1 <- rnorm(n=n)
x2 <- rnorm(n=n)
y <- 2*x1 + 3*x2 + rnorm(n=n)
df <- round(data.frame(y = y, x1 = x1, x2 = x2))

req_5 <- request("http://165.22.92.178:8080") %>%
  req_url_path("lm") %>%
  req_body_json(as.list(df)) %>%
  req_headers(authorization = "DM_DV_123#!")

resp <- req_perform(req_5)
resp_body_json(resp)

# Exercise 6+7
req_7 <- request("https://google-translate1.p.rapidapi.com/language/translate/v2/detect") %>%
  req_body_form(q = "Hallo, mein nahme ist Frank") %>%
  req_headers(
              'x-rapidapi-key' = "e2cfc6c104msh774c99e60458f59p15c0c3jsn117070aad870",
              'x-rapidapi-host' = 'google-translate1.p.rapidapi.com')
              
resp <- req_perform(req_7)
resp_body_json(resp)


