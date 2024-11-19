library(cronR)

cron_clear()
cron_ls()


# EXERCISE 10
# First cronR job -------------
cmd <- cron_rscript(rscript = "/home/rstudio/git_training/scheduling/Given_Files/increment_one.R")
cron_add(cmd, frequency = 'minutely', id = 'job1', 
         days_of_week = 7, description = 'Our first cronR job')

# EXERCISE 11
# Second cronR job -------------
cmd <- cron_rscript(rscript = "/home/rstudio/git_training/scheduling/Given_Files/increment_one.R")
cron_add(cmd, frequency = 'daily', id = 'job2', at = '04:00', 
         days_of_month = 15, description = 'Our second cronR job')
cron_ls()

# EXERCISE 12
cron_save(file = "my_BI_schedule")
cron_clear()

cron_load(file = "/home/rstudio/git_training/scheduling/My_Files/my_BI_schedule")
cron_ls()
cron_clear()


# EXERCISE 13
cmd <- cron_rscript(rscript = "/home/rstudio/git_training/scheduling/Given_Files/increment_one.R")
cron_add(cmd, frequency = 'minutely', id = 'job100', 
         description = 'Our first cronR job')

cmd <- cron_rscript(rscript = "/home/rstudio/git_training/scheduling/Given_Files/increment_one.R")
cron_add(cmd, frequency = 'hourly', id = 'job101', 
         description = 'The hourly job')

cron_ls()
cron_clear()

