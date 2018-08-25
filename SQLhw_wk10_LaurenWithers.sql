-- 1a. Display the first and last names of all actors from the table actor.
USE sakila; 

SELECT a.first_name, a.last_name
FROM actor a; 

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.  
SELECT CONCAT(a.first_name, ' ', a.last_name) as actor_name
FROM actor a; 


-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT a.actor_id, a.first_name, a.last_name
FROM actor a
WHERE a.first_name="JOE"; 

-- 2b. Find all actors whose last name contain the letters GEN:
SELECT a.actor_id, a.first_name, a.last_name
FROM actor a
WHERE a.last_name LIKE '%GEN%'; 

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT a.actor_id, a.first_name, a.last_name
FROM actor a
WHERE a.last_name LIKE '%LI%'
ORDER BY a.last_name, a.first_name; 

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT c.country_id, c.country 
FROM country c
WHERE c.country IN ("Afghanistan", "Bangladesh", "China"); 


-- 3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.
SELECT * 
FROM actor a;
ALTER TABLE actor
ADD COLUMN middle_name VARCHAR(50) AFTER first_name; 

DESCRIBE sakila.actor;

-- 3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.
SELECT * 
FROM actor a;
ALTER TABLE actor 
MODIFY COLUMN middle_name BLOB; 

DESCRIBE sakila.actor;

-- 3c. Now delete the middle_name column.
SELECT * 
FROM actor;
ALTER TABLE actor
DROP COLUMN middle_name; 

DESCRIBE sakila.actor;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(*) AS 'same_last' 
FROM actor
GROUP BY last_name; 

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(*) AS 'same_last' 
FROM actor
GROUP BY last_name 
HAVING same_last >= 2; 

-- 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
UPDATE actor
SET first_name= 'HARPO' 
WHERE first_name= 'GROUCHO' AND last_name= 'WILLIAMS'; 

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! (Hint: update the record using a unique identifier.)
UPDATE actor
SET first_name= 'GROUCHO' 
WHERE first_name= 'HARPO' AND last_name= 'WILLIAMS'; 


-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it? Hint: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html 
DESCRIBE sakila.address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT s.first_name, s.last_name, d.address 
FROM staff s LEFT JOIN address d
ON s.address_id = d.address_id
ORDER BY s.last_name; 

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT s.first_name, s.last_name, SUM(p.amount) AS 'total_rung' 
FROM staff s LEFT JOIN payment p ON s.staff_id = p.staff_id
ORDER BY s.last_name; 
-- SELECT s.first_name, s.last_name, p.payment_date, p.amount
-- FROM staff s LEFT JOIN payment p ON s.staff_id = p.staff_id
-- WHERE p.payment_date LIKE '%2005%' 
-- SUM(p.amount) AS 'total_rung' 
-- GROUP BY s.last_name;  

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT f.title, COUNT(r.actor_id) AS 'num_actors' 
FROM film_actor r INNER JOIN film f ON r.film_id = f.film_id
GROUP BY f.title; 

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system? 
SELECT f.title, COUNT(i.store_id) AS 'num_inven'
FROM inventory i INNER JOIN film f ON i.film_id = f.film_id
GROUP BY f.title 
HAVING f.title = 'Hunchback Impossible'; 

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name 
/*  
SELECT j.first_name, j.last_name, SUM(p.amount) AS 'total_paid' 
FROM customer j LEFT JOIN payment p ON j.cutomer_id = p.customer_id
GROUP BY j.first_name, j.last_name
ORDER BY j.last_name 
*/
SELECT c.first_name, c.last_name, SUM(p.amount) AS 'total_paid'
FROM customer c LEFT JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.first_name, c.last_name
ORDER BY c.last_name;


-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English. 
SELECT f.title 
FROM film f 
WHERE (f.title LIKE 'K%' OR f.title LIKE 'Q%') 
AND f.language_id=(SELECT language_id FROM language where name='English'); 

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
/*
SELECT a.first_name, a.last_name 
FROM film f LEFT JOIN film_actor r ON r.film_id = f.film_id
FROM actor a INNER JOIN film_actor r ON r.acrtor_id = a.actor_id 
WHERE (f.title LIKE 'Alone')
GROUP BY a.last_name; */   
SELECT first_name, last_name
FROM actor
WHERE actor_id
	IN (SELECT actor_id FROM film_actor WHERE film_id 
		IN (SELECT film_id from film where title='ALONE TRIP'))

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.

*********???????************* 

SELECT first_name, last_name, email 
FROM customer j 
JOIN address a ON (j.address_id=a.address_id) 
JOIN city ci ON (a.city_id=ci.city_id) 
JOIN country cn ON (ci.country_id=cn.country_id) 

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT title, c.name 
FROM film f
JOIN film_category fcat ON (f.film_id=fcat.film_id)
JOIN category c ON (fcat.category_id=c.category_id)
WHERE c.name 
	IN (SELECT c.name FROM category c WHERE name='Family');

-- 7e. Display the most frequently rented movies in descending order.
SELECT f.title, COUNT(i.inventory_id) AS 'Freq_Rented' 
FROM film f 
JOIN inventory i ON f.film_id= i.film_id
GROUP BY f.title 
ORDER BY Freq_Rented DESC; 

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT s.store_id, SUM(p.amount) AS 'dollars_brought_in'
FROM payment p JOIN staff s ON p.staff_id=s.staff_id 
GROUP BY s.store_id
ORDER BY dollars_brought_in;

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT t.store_id, ci.city, cn.country
FROM store t  
JOIN address a ON (t.address_id=a.address_id) 
JOIN city ci ON (a.city_id=ci.city_id) 
JOIN country cn ON (ci.country_id=cn.country_id);

-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

-- -------------**********-------------- 

SELECT c.name, SUM(p.amount) AS "gross" 
FROM category c
JOIN film_category fc ON (c.category_id=fc.category_id)
JOIN inventory i ON (fc.film_id=i.film_id)
JOIN rental r ON (i.inventory_id=r.inventory_id)
JOIN payment p ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross LIMIT 5; 


-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW top_gross_genres AS
SELECT c.name, SUM(p.amount) AS "Gross" 
FROM category c
JOIN film_category fc ON (c.category_id=fc.category_id)
JOIN inventory i ON (fc.film_id=i.film_id)
JOIN rental r ON (i.inventory_id=r.inventory_id)
JOIN payment p ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross LIMIT 5;  

-- 8b. How would you display the view that you created in 8a?
SELECT * FROM top_gross_genres;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW top_gross_genres;


