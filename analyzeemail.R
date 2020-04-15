install.packages(c("tidyverse","lubridate"))
library(tidyverse)
library(lubridate)
install.packages("esquisse")
library(esquisse)
install.packages("gmailr")
library(gmailr)
install.packages(c("wordcloud","Rcolorbrewer","tm"))
library (wordcloud)
library(tm)


getwd()
setwd("C:/Users/PALLAVI.VENKATESHAN/Desktop")

gm_auth_configure(key = "923922576143-pb5n1rdtc1jlnb3nq5p2ekdpuecgaldn.apps.googleusercontent.com", secret = "n0kQBz64ZXw5krhJR-KTqgQt",
                  path = Sys.getenv("C:/Users/PALLAVI.VENKATESHAN/Desktop/ProjectRcode.json"), appname = "ProjectRcode",
                  app = httr::oauth_app("ProjectRcode",key="923922576143-pb5n1rdtc1jlnb3nq5p2ekdpuecgaldn.apps.googleusercontent.com",secret="n0kQBz64ZXw5krhJR-KTqgQt"))
gm_oauth_app()

token <- gm_auth(cache = FALSE)
gm_token()
saveRDS(token, file = "gmail_token.rds")


messageID <- gm_messages("from:paytmmoney",100)

my_messages <- messageID[[1]]$messages %>%
  modify_depth(1,"id") %>%
  as.vector() %>%
  map(message)

write_rds(my_messages,"swiggymails.rds")


my_messages[[1]] %>% gm_body %>% unlist 

EmailTemplates <- tibble(
  id = my_messages %>% map_chr(gmailr::id),
  subject = my_messages %>% map_chr(subject),
  date = my_messages %>% map_chr (gmailr::date) %>% dmy_hms,
  bodyLength = my_messages %>% map_int(~body(.) %>% unlist %>% str_length),
  from = my_messages %>% map_chr(from)
)


EmailTemplates$subject 
as.vector(unlist(EmailTemplates$subject))
a <- EmailTemplates$subject

Subs <- Corpus(VectorSource(a))

Swiggy_Subjects <- tm_map(Subs,stripWhitespace)
Swiggy_Subjects <- tm_map(Swiggy_Subjects,tolower)
Swiggy_Subjects <- tm_map(Swiggy_Subjects,removePunctuation)
Swiggy_Subjects <- tm_map(Swiggy_Subjects,removeWords, stopwords("english"))
Swiggy_Subjects <- tm_map(Swiggy_Subjects,removeNumbers)
Swiggy_Subjects <- tm_map(Swiggy_Subjects,removeWords, c("Start","investing","kyc","complete","invest","submit","details","new","Feb","Jan","Food", "Must","Your"))

rm(Swiggy_Subjects)                          

wordcloud(Swiggy_Subjects,scale=c(5,0.5),max.words = 20, random.order=FALSE, rot.per=0.35, use.r.layout=FALSE, colors = "black")
                 
tdm_Swiggy <- TermDocumentMatrix(Swiggy_Subjects)
TDM1 <- as.matrix(tdm_Swiggy)
v= sort(rowSums(TDM1),decreasing = TRUE)
print(v)

esquisser(EmailTemplates)

quit(save = "default", status = 0, runLast = TRUE)
