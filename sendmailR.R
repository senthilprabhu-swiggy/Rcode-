install.packages("mailR", dep = T)
library(mailR)
send.mail (from = "pallavi.venkateshan@swiggy.in",
           to = "pvvortex@gmail.com",
           subject = "Subject of the email",
           body = "Body of the email",
           smtp = list(host.name = "smtp.gmail.com", port = 465, user.name = "pallavi.venkateshan@swiggy.in", passwd = "Skadoosh102##$", ssl = TRUE),
           authenticate = TRUE,
           send = TRUE)