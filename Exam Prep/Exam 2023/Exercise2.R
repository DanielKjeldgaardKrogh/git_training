
# Exercise 2

library(httr2)

req <- request("http://165.22.92.178:8080") %>%
  req_url_path("/letters") %>%
  req_url_query("letter_seed" = 9) %>%
  req_headers(authorization = "123#!1_DM_DV") %>%
  req_body_json(list(which_letter = c("d", "a", 
                                       "n"))
                )


resp <- req %>%
  req_perform()

resp %>%
  resp_body_json()
