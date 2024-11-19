library(cronR)
# We will execute the increment_one.R script in the following cron jobs
cmd <- cron_rscript(rscript = "increment_one.R")
# Exercise 10
# Assuming the current day is Saturday
cron_add(cmd, frequency = 'minutely', id = 'job7', days_of_week = c(6))
# Exercise 11
cron_add(cmd, frequency = 'daily', id = 'job8', days_of_month = c(15),
         at = "04:00")
# Exercise 12
cron_save(file = "my_BI_schedule")
cron_clear()
cron_load(file = "my_BI_schedule")
cron_ls()
cron_clear()
