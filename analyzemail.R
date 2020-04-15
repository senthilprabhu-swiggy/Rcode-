library(tidyverse)
library(lubridate)
install.packages("esquisse")
library(esquisse)
library(gmailr)

?messages

gm_auth_configure(key = "923922576143-pb5n1rdtc1jlnb3nq5p2ekdpuecgaldn.apps.googleusercontent.com", secret = "n0kQBz64ZXw5krhJR-KTqgQt",
                  path = Sys.getenv("C:/Users/61610417/Desktop/ProjectRcode.json"), appname = "ProjectRcode",
                  app = httr::oauth_app("ProjectRcode",key="923922576143-pb5n1rdtc1jlnb3nq5p2ekdpuecgaldn.apps.googleusercontent.com",secret="n0kQBz64ZXw5krhJR-KTqgQt"))
gm_oauth_app()

token <- gm_auth(cache = FALSE)
gm_token()
saveRDS(token, file = "gmail_token.rds")

messageID1 <- gm_messages("from:swiggy",50)

messageID1

my_messages <- messageID1[[1]]$messages %>%
  modify_depth(1,"id") %>%
  as.vector() %>%
  map(message)

write_rds(my_messages,"swiggymails.rds")

my_messages[[1]] %>% gm_body %>% unlist 

EmailTemplates <- tibble(
  id = my_messages %>% map_chr(id),
  subject = my_messages %>% map_chr(subject),
  date = my_messages %>% map_chr (gmailr::date) %>% dmy_hms,
  bodyLength = my_messages %>% map_int(~body(.) %>% unlist %>% str_length),
  
  from = my_messages %>% map_chr(from)
)

EmailTemplates


esquisser(EmailTemplates)

quit(save = "default", status = 0, runLast = TRUE)
