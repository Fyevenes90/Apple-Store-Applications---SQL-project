--Exploratory Data Analysis (EDA)

--Check the # of unique apps
with 
CTE1 as (
SELECT DISTINCT COUNT(ID) as Unique_Id_AppleStore
FROM AppleStore), 
CTE2 AS(
SELECT DISTINCT COUNT(ID) as Unique_Id_C_Apple_Decription
FROM Combine_Apple_Decription)
 
 select *
from CTE1, CTE2



--Lets check for Nulls values in AppleStore
SELECT COUNT(*) as Missing_Values
from AppleStore
where 
Id is NULL or user_rating is NULL or price is null


--Lets check for Nulls values in combine_Apple_Decription
SELECT COUNT(*) as Missing_Values_Combine_Apple_Decription
from Combine_Apple_Decription
where 
Id is NULL or track_name is NULL or app_desc is null


--Lets find out the number of apps per genderAppleStore
SELECT  prime_genre, COUNT(id) AS Count_of_Apps
FROM AppleStore
GROUP BY prime_genre
order by Count_of_Apps desc

--Lets do an overview of the user rating from the applestore
SELECT prime_genre, 
MIN(user_rating) Min_user_rating,
Max(user_rating) Max_user_rating,
Avg(user_rating) Max_user_rating

FROM AppleStore



--Lets do an overview of the price from the applestore
SELECT prime_genre, 
MIN(price) Min_price_rating,
Max(price) Max_price_rating,
Avg(price) Max_price_rating

FROM AppleStore


--Lets check in how many difference currency you can buy an app
SELECT DISTINCT currency, count(id) Count_of_apps
from AppleStore
group by currency


--Lets see how many languages we have 
SELECT lang_num
from AppleStore

------Finding Insights
--Determine whether paid apps have higher ratings than free ones
SELECT 
case 
	WHEN price >0 THEN 'Paid'
	else 'Free' 
    end as 'App_type',
Avg(user_rating) as Avg_Rating
FROM AppleStore
group by App_type 



--Lets see if apps that have more languages have better ratingsAppleStore
SELECT 
case  
	when lang_num <10 then 'Less than 10'
    when lang_num BETWEEN 10 aND 30 then 'Less btw 10 & 30'
    when lang_num > 30 then 'More than 30'
    end as 'Language_range',
    round(avg(user_rating),2) as Avr_user_rating
  
from AppleStore
GROUP by Language_range
order by Avr_user_rating desc



--Lets see all the apps gender with bad rating
select prime_genre, round(avg(user_rating),2) as avg_rating_user
from AppleStore
GROUP by prime_genre  
order by avg_rating_user asc
LIMIT 10

--Lets check if there's a correlation between the len of the description and the ratingAppleStore
SELECT 
CASE  
	WHEN LENGTH(A.app_desc) <=100  then 'Equal or less than 100 characters'
    WHEN LENGTH(A.app_desc) BETWEEN 100 and 200  then 'Between 100 & 200 characters'
    WHEN LENGTH(A.app_desc) >100  then 'more than 200 characters'
end as 'Length_Description',
avg(B.user_rating) as Average_User_rating
from Combine_Apple_Decription as A
left join AppleStore B on A.id = B.id
GROUP BY Length_Description
ORDER BY Average_User_rating desc


---Check the top apps for each gender 
SELECT
prime_genre,
track_name,
user_rating
FROM (

  SELECT 
  prime_genre,
  track_name,
  user_rating,
  RANK() OVER (PARTITION BY prime_genre order BY user_rating DESC, rating_count_tot desc) RANKING_COUNT
FROM AppleStore  ) AS A

 where a.RANKING_COUNT =1
 
 
 ---Lets try with the worst apps ranking
 
 with cte1 as (
   SELECT prime_genre,
   		  track_name,
   		  user_rating,
   		 
   FROM AppleStore
   WHERE user_rating >1
   ORDER BY user_rating ASC)
   
   --SELECT *
   --from cte1
   
 
 
 select 
 prime_genre,
 track_name,
 user_rating
 from 
       (select
       prime_genre,
       track_name,
       user_rating,
       RANK() OVER (partition by prime_genre order by user_rating asc, rating_count_tot asc) as Rank_worst_apps
        FROM cte1  ) as Check_bad_apps 


   where 
   Check_bad_apps.Rank_worst_apps=1 
   
