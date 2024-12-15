
library(httr2)

req <- request("http://165.22.92.178:8080") %>%
  req_url_path("/names") %>%
  req_url_query("name_seed" = "100") %>%
  req_body_json(list(which_name = c("John",
                                    "Martin", "Jonas"))) %>%
  req_headers(authorization = "123#!2_DM_DV")

resp <- req %>%
  req_perform()

response <- resp %>%
  resp_body_json()
