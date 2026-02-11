-- show the username of the user who were tagged in caption or photo before january 7th , 2010,also show the date that they were tagged
select * from users;


select username, tags.created_at
from users join (
(select created_at,user_id from caption_tags) union all
(select created_at, user_id from photo_tags)
) as tags on tags.user_id=users.id where tags.created_at < '2010-01-07';

-- above scenario can we done by using CTE --simple query make easy to undestand 
WITH tags as(
(select created_at,user_id from caption_tags) union all
(select created_at, user_id from photo_tags)
);

select username, tags.created_at
from users join tags on tags.user_id=users.id where tags.created_at < '2010-01-07';