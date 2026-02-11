-- select 3 users with higest id from user tables
select * from users;
select * from users order by id desc limit 3;

-- join the users and posts table , show the username of user id 200 and captions of all post they have created

select username, caption
from users join posts on users.id=posts.user_id where users.id=200;

-- show each username and numbers of like that they have created
select  user_id, count(*)
from likes 
group by user_id ;

select username, count(*)
 from likes join users on likes.user_id=users.id group by username ;