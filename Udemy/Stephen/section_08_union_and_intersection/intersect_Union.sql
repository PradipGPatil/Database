 -- find the 4 products with the higest price and the 4 products
 -- with the higest price/weight ratio
 (select * from products order by price desc limit 4)union
 (select * from products order by price/weight desc limit 4);-- if both dataset have same value then it will remove duplicate value 

 (select * from products order by price desc limit 4)union all 
 (select * from products order by price/weight desc limit 4);  -- if we do not want to remove duplicate


(select * from products order by price desc limit 4)intersect
 (select * from products order by price/weight desc limit 4); -- return value which is common in both dataset and remove duplicate

-- insersect all find the result set 
 (select * from products order by price desc limit 4)intersect all  -- return either same result either 1 st dataset  or 2nd result dataset 
 (select * from products order by price/weight desc limit 4);


 (select * from products order by price desc limit 4)EXCEPT  -- find the result which is availabe in first qeury but not in second query
 (select * from products order by price/weight desc limit 4);
 