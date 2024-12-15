
library(RPostgres)
library(DBI)

source("/home/rstudio/git_training/credentials.R")
source("/home/rstudio/git_training/Exam Prep/psql_queries.R")

psql_manipulate(cred = cred_psql_docker,
                query_string = "create table public.q1(
                post_id serial primary key,
                some_source varchar(50),
                post_title varchar(500),
                fraction_like_views decimal(9,2)
                );
              ")

psql_manipulate(cred = cred_psql_docker,
                query_string = "                
                insert into public.q1
                values
                (default, 'fb', 'See pics of my wonderful day', 0.21),
                (default, 'reddit', 'Is Apple equity traded each day?', 0.01),
                (default, 'x', 'Why I celebrate the international nurses day', 2.09);
                
              ")

psql_select(cred = cred_psql_docker,
            query_string = "select * from public.q1;
            ")

psql_manipulate(cred = cred_psql_docker,
                query_string = "create index idx_fraction_like_views
                on public.q1(fraction_like_views)
                ")
                
                
psql_select(cred = cred_psql_docker,
                query_string = "select * from public.q1
                where post_title like ('%day')
                ")

psql_select(cred = cred_psql_docker,
            query_string = "select * from public.q1
            where post_title like ('_h%')
            ")
