--netflix project ---
create table netflix
(
 show_id	VARCHAR(6),
 "type"  VARCHAR(10),
 title	VARCHAR(150),
 director VARCHAR(208),
 "cast"    VARCHAR(1000),
 country	VARCHAR(150),
 date_added	VARCHAR(50),
 release_year	INT,
 rating	VARCHAR(10),
 duration  VARCHAR(15),	
 listed_in    VARCHAR(100),
 description VARCHAR(250)
 );

 select * from netflix

select count(*) as total_content  from netflix 

---15 business problems___
--1. count number of movies vs number of tv show ---
select 
     type ,
	 count(*) as total_content 
from netflix 
group by type 

--2. find the most rating for tvs and the move shows ----
select 
     type,
	 rating
	 from (select 
     type ,
	 rating,
	 count(*) ,
	 rank()over(partition by type order by count(*)desc) as ranking 
	 from netflix 
	 group by 1,2) as t1 
where 
     ranking= 1

---3, list all the movies released in the specific year ---
select * from netflix 
where 
    type ='movie'
	and 
	release_year = 2020
---4.find the top 5 countries with the most content on netflix---

select 
     UNNEST(STRING_TO_ARRAY(country,',')) as new_country , 
	 count(show_id) as total_content 
	 from netflix 
	 group by 1 
	 order by 2 desc 
	 limit 5 

---5. identify the longest movie?---

select * from netflix 
where 
type ='movie'
and
duration=(select max (duration)from netflix)

--6.find content added in the last 5 years ---

select * from netflix 
where 
TO_date(date_added,'MONTH DD,YYY')>= current_date - Interval '5 year'

--7. find alll the movie and tv shows directed by the rajiv chilaka'--
select * from netflix 
where director='Rajiv chilaka'

---8.list all tv shows with more than 5 seasons ----

select * from netflix 
where 
     type ='tv shows'
	 and 
	 SPLIT_PART(duration,'',1)::numeric>5
----9.count number of content iteam in the each genre---
select 
     UNNEST(STRING_TO_ARRAY(listed_in,1,1)) as genre,
	 count(show_id)as total_content 
	 from 
	 group by 1 
---10. find each year and the average number of content relased in INdia on netflix retutn top 5 year with hihest avg content relased ----
select 
     EXCTRACT(YEAR FROM TO_DATE (date_added,'month DD,YYY'))as year , 
	 count(*),
	 count(*)::numeric/(select count(*)from netflix where country ='INDIA')::numeric*100asavg_content_per_year
	 from netflix 
	 where country ='India'
	 group by 1 
---11. list all movies that are documentries --
select * from netflix 
where 
    listed_in Ilike '%documentaries%'

---12.find all the flim without director---

select * from netflix 
where 
    director is NULL
---13.find how many movies actor 'salman khan' appeared in last 10 years ----

select * from netflix 
where 
cast Ilike '%salamn khan'
and 
release_year>Extract(year from current date)-10

---14. find the 10 actors who have appeared in the highest numbers of movie produced in india ---

select 
UNNEST (STRING_TO_ARRAY(CAST,''))as actors,
count(*) as total_content 
from netflix 
where country Ilike '%india'
group by 2 desc 
limit 10 

----15.cateogries the content based the preseneco fthe key word 'kill' and 'violence' in the description filed lable content containing these key word as bad and all the other good count how many iteams fall into these cateogies 
with new_table 
as 
(select *, case when 
           description Ilike '%kill%'or
		   description Ilike '%violence'then 'bad_content '
		   else 'good content'
		   end category
		   from netflix 
		   )
select category , 
        count (*) as total_content from new_tablr 
		group by 1