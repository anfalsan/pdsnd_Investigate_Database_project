# Query 1 , question: What films have the highest number of rental orders for the animation category?
select f.title as film_name, ca.name as Category_name, count(r.inventory_id) as count_rental
fROM rental r
JOIN inventory i
ON r.inventory_id = i.inventory_id
JOIN film f
ON i.film_id = f.film_id
JOIN film_category fc
ON f.film_id = fc.film_id
JOIN category ca
ON fc.category_id = ca.category_id
where ca.name in ('Animation')
group by 1,2
order by 3 desc
limit 10;

#Query 2 , question: Which category has the most movies?
select ca.name as Category_name, count(f.film_id) as count_films ,
 NTILE(16) OVER (ORDER BY ca.name ) AS number_category
 from film f
 JOIN film_category fc
 ON f.film_id = fc.film_id
 JOIN category ca
 ON fc.category_id = ca.category_id
 group by 1
 order by 1 ;

# Query 3 , question: who are the top 10 customers with highest amount?
with t1 as (SELECT CONCAT(c.first_name, '  ', c.last_name) as full_name , p.amount amount , co.country country_name  , sum(amount) total_amount
FROM payment p
JOIN customer c
ON p.customer_id = c.customer_id
JOIN address a
ON c.address_id = a.address_id
JOIN city ci
ON a.city_id = ci.city_id
join country co
on ci.country_id = co.country_id
GROUP BY 1,2 ,3
ORDER BY 4 DESC) ,
 t2 as (SELECT country_name, MAX(total_amount) total_amount
        FROM t1
        GROUP BY 1)
        SELECT t1.full_name, t1.country_name, t1.total_amount
        FROM t1
        JOIN t2
        ON t1.country_name = t2.country_name AND t1.total_amount = t2.total_amount
        limit 10;

# Query 4 , question: What is the lowest count rental duration in two of the quartiles for family-friendly film categories?
WITH t1 AS (SELECT f.title file_name, c.name category_film, f.rental_duration rental_duration,
NTILE(4) OVER (ORDER BY f.rental_duration ) AS standard_quartile
FROM category c
JOIN film_category fc
ON fc.category_id=c.category_id
JOIN film f
ON fc.film_id=f.film_id
WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
ORDER BY 3,1)
  SELECT category_film, standard_quartile, COUNT(standard_quartile)
  FROM t1
  where standard_quartile in (1, 2)
  GROUP BY 1,2
  ORDER BY 1,2
