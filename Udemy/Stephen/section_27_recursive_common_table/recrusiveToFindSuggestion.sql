 with RECURSIVE countdown(val) as (
 select 3 as val  -- initial or no recursive query
 union  -- always have union keyword
 select val-1 from countdown where val>1  -- recrusive query
 )

 select * from countdown;

with recursive suggestion(leader_id,follower_id,depth) as (
	select leader_id,follower_id ,1 as depth  from followers where follower_id=1000 -- we are assuming that we want to find suggestion for user_id 1000
union
	select followers.leader_id, followers.follower_id,depth+1 from followers
	join suggestion on suggestion.leader_id=followers.follower_id
	where depth <3
 )

 select distinct users.id,users.username
 from suggestion join users on users.id=suggestion.leader_id
 where depth<3 limit 30;