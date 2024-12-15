
library(RPostgres)
library(DBI)

source("/home/rstudio/git_training/credentials.R")
source("/home/rstudio/git_training/Exam Prep/psql_queries.R")

psql_manipulate(cred = cred_psql_150,
                query_string = "create table public.q1(
                article_id serial primary key,
                article_source varchar(200),
                article_title varchar(300),
                article_imported timestamp(0) without time zone default current_timestamp(0));
                ")

psql_manipulate(cred = cred_psql_150,
                query_string = "insert into public.q1
                values
                (default, 'wsj', 'Inflation rises to record high', default),
                (default, 'ft', 'Oil prices are record high', default),
                (default, 'nyt', 'High costs of cleaner air', default)
                ")

psql_select(cred = cred_psql_150,
            query_string = "select * from public.q1;")


psql_manipulate(cred = cred_psql_150,
                query_string = "delete from public.q1
                where article_id = 1;
                ")

psql_select(cred = cred_psql_150,
            query_string = "select * from public.q1;")

psql_manipulate(cred = cred_psql_150,
                query_string = "delete from public.q1
                where article_source = 'ft';
                ")

psql_select(cred = cred_psql_150,
            query_string = "select * from public.q1;")

psql_manipulate(cred = cred_psql_150,
                query_string = "create index idx_article_source
                                on public.q1(article_source);
                ")

psql_manipulate(cred = cred_psql_150,
                query_string = "drop table public.q1;
                ")


psql_select(cred = cred_psql_150,
            query_string = "select * from public.q1;")



