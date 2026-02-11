-- use join practice database
-- for each comments show the contents of the comment and username of the user who wrote the comment
select contents, username from users join comments on users.id=comments.user_id;

-- for each comment ,list the content of the comment and url of the photo the comment was added to 
select contents,url
from comments join photos on comments.photo_id=photos.id;

-- show each photo url and username of the poster
-- here we have one url which has null value fro user id 
insert into photos(url,user_id) values('https:mysample.com',null);

select url, username 
from photos left join users on photos.user_id=users.id;


-- user can comment on photo that they posted. Find the url  and content of every photo / comment where
-- users is commenting on own post

select url, contents
from photos join comments on photos.id=comments.photo_id where photos.user_id=comments.user_id;

-- also find username for above scenario

select username,url,contents
from photos join comments on photos.id=comments.photo_id 
join users on users.id=photos.user_id and users.id=comments.user_id ;

-- find number of the comment for each photo
 select photo_id, count(*)
 from comments group by photo_id ;

 -- find the number of comments for each photo where the 
 -- photo_id is less than 3 and the photo has more than 2 comments
select count(*),photo_id
from comments where photo_id <3 group by photo_id having count(*)>2;

-- find the users (user_id) where the user has commented on the 
-- first 2 photos(on photos_id 1 and 2 ) and 
-- user added more than 2 comments on those photos

select photo_id, count(*)
from comments where photo_id<=2 group by photo_id having count(*)>2;

-- find the users where the user has commented on the first 50 photos
-- and the user added more than 20 comments on those photos

select user_id, count(*)
from comments where photo_id <50 group by user_id having count(*)>20;











