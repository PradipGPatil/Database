create table users(
id serial primary key,
created_at timestamp with time zone default current_TIMESTAMP,
updated_at TIMESTAMP with time zone default current_timestamp,
username varchar(40) not null,
bio varchar(200),
avatar varchar(25),
phone varchar(25),
email varchar(50),
password varchar(50),
status varchar(20),
CHECK(COALESCE(phone, email )is not null)

);
select * from users;

create table posts(
id serial primary key,
created_at timestamp with TIME zone default CURRENT_TIMEstamp,
updated_at timestamp with time zone default CURRENT_TIMESTAMP,
url varchar(200) not null,
caption varchar(240),
lat real check(lat is null or (lat >-90 and lat<90)),
lang real check (lang is null or (lang>-180 and lang <180)),
user_id integer not null references users(id) on delete cascade
);
select * from posts;

create table comments(
id serial primary key,
created_at timestamp with time zone default current_timestamp,
updated_at timestamp with time zone default current_timestamp,
contents varchar(240) not null,
user_id integer not null references users(id) on delete cascade,
post_id integer not null references posts(id) on delete cascade

);
select * from comments;

create table likes(
id serial primary key,
created_at timestamp with time zone default current_timestamp,
user_id integer not null references users(id) on delete cascade,
post_id integer not null references posts(id) on delete cascade,
comment_id integer not null references comments(id) on delete cascade,
check(COALESCE((post_id::boolean::integer),0) + COALESCE((comment_id::boolean::integer),0)=1),
unique(user_id,post_id,comment_id)
)
select * from likes;

create table photo_tags(
id serial primary key,
created_at timestamp with time zone default current_timestamp,
updated_at timestamp with time zone default current_timestamp,
x integer,
y integer,
user_id integer not null references users(id) on delete cascade,
post_id integer not null references posts(id) on delete cascade,
unique(user_id, post_id)
);
select * from photo_tags;

create table caption_tags(
id serial primary key,
created_at timestamp with time zone default CURRENT_TIMESTAMP,
post_id integer not null references posts(id) on delete cascade,
user_id integer not null references users(id) on delete cascade,
unique(post_id,user_id)

);
select * from caption_tags;


create table hastags(
id serial primary key,
created_at timestamp with time zone default current_timestamp,
name varchar(250) not null

select * from hastags;

create table hastag_posts(
id serial primary key,
hastag_id integer not null references hastags(id) on delete cascade,
post_id integer not null references posts(id) on delete cascade,
unique(hastag_id,post_id)
);
select *from hastag_posts;

create table follower(
id serial primary key,
leader_id integer not null references users(id) on delete cascade,
follower_id integer not null references users(id) on delete cascade,
unique(leader_id, follower_id)
);
select * from follower;







