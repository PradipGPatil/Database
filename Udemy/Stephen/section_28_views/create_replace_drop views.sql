-- show the most popular users - the user who were tagged most 
select * from photo_tags;
select * from caption_tags;
-- here we want to find user_id which were tagged most of time so we will use union

select user_id from photo_tags 
union all
select user_id from caption_tags;

select username, count(*)
from users join (
select user_id from photo_tags 
union all
select user_id from caption_tags
) as tags on tags.user_id=users.id group by username order by count(*) desc;

-- suppose we want to execute union query multiple time this was mistake in database design 
-- option 1 : create single table
-- cannot copy as both table have unique id and brake existing query that refer to the both table 

-- view created ahed of time and refer any time 

create view tags as (
	select id, created_at, user_id,post_id ,'photo_tag' as type from photo_tags -- as type add column 'photo-tag' and 'caption_tags'
Union all 
	select id, created_at, user_id, post_id , 'caption_tag' as type from caption_tags
);

select * from tags;

-- now we can make changes to above query 

select username, count(*)
from users join  tags on tags.user_id=users.id group by username order by count(*) desc;

-- create view for most 10 recent post
select * from users;
select * from posts;

create view recent_post as (
select username from users join posts on users.id=posts.user_id order by posts.created_at desc limit 10
);

create or replace view recent_post as(
select username from users join posts on users.id=posts.user_id order by posts.created_at desc limit 15
);

select * from recent_post;

-- deleting view 
drop view recent_post;










