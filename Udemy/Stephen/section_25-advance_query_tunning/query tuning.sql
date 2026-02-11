show data_directory;
select oid , datname from pg_database;
select * from pg_class;

select * from users;
create index on users(username);

drop index users_username_idx;

-- without  index 1.28 ms
explain analyze select * from users where username='Emil30';


-- with index  takes around 0.093 ms
explain analyze select * from users where username='Emil30';


select pg_size_pretty(pg_relation_size('users')); -- 872 kb for table users 
select pg_size_pretty(pg_relation_size('users_username_idx')); -- 184 kb for index 

-- to check index for pk and unique
select relname,relkind from pg_class where relkind='i';


create extension pageinspect;

select * from bt_metap('users_username_idx');-- bt b tree , mtp stands for metaspace 
-- check root page value which is at 3 so root page is at index 3 

select * from bt_page_items('users_username_idx',3); -- bt for all specific item for page 3 
-- if we satisfy some data criteria the go to ctid 
