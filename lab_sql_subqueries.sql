USE sakila;

-- Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
SELECT * FROM sakila.film; -- film_id, title
SELECT * FROM sakila.inventory; -- inventory_id, film_id

SELECT 
	COUNT(*) AS number_of_copies
FROM sakila.inventory
WHERE film_id = (
	SELECT film_id 
    FROM sakila.film 
    WHERE title = 'Hunchback Impossible'
);

-- List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT 
	f.title,
    f.length
FROM sakila.film AS f
WHERE f.length > (
	SELECT AVG(length) 
    FROM sakila.film
);

-- Use a subquery to display all actors who appear in the film "Alone Trip".
SELECT * FROM sakila.actor; -- actor_id, first_name, last_name
SELECT * FROM sakila.film; -- film_id, title
SELECT * FROM sakila.film_actor; -- actor_id, film_id

SELECT 
	a.first_name,
    a.last_name
FROM sakila.actor as a
JOIN sakila.film_actor as fa ON a.actor_id = fa.actor_id
WHERE fa.film_id = (
	SELECT f.film_id
    FROM sakila.film as f
	WHERE f.title = 'Alone Trip'
);

-- Identify all movies categorized as family films.
SELECT * FROM sakila.category; -- category_id, name
SELECT * FROM sakila.film; -- film_id, title
SELECT * FROM sakila.film_category; -- film_id, category_id

SELECT 
	f.film_id,
    f.title 
FROM sakila.film as f
JOIN sakila.film_category as fc ON f.film_id = fc.film_id 
WHERE fc.category_id = (
	SELECT c.category_id
    FROM sakila.category as c
    WHERE c.name = 'Family'
);

-- Retrieve the name and email of customers from Canada using both subqueries and joins. 
-- To use joins, you will need to identify the relevant tables and their primary and foreign keys.
SELECT * FROM sakila.customer; -- customer_id, first_name, last_name, email, address_id
SELECT * FROM sakila.address; -- address_id, city_id
SELECT * FROM sakila.country; -- country_id, country 
SELECT * FROM sakila.city; -- city_id, country_id

SELECT 
	CONCAT(c.first_name, ' ', c.last_name) as customer_name,
    c.email
FROM sakila.customer as c
JOIN sakila.address as a ON c.address_id =  a.address_id
JOIN sakila.city as ci ON a.city_id = ci.city_id
WHERE ci.country_id = (
	SELECT co.country_id
    FROM sakila.country as co
    WHERE co.country = 'Canada'
);


-- Determine which films were starred by the most prolific actor in the Sakila database. 
-- First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in
SELECT * FROM sakila.actor; -- actor_id, first_name, last_name
SELECT * FROM sakila.film; -- film_id, title
SELECT * FROM sakila.film_actor; -- actor_id, film_id

-- First, find the most profilic actor
SELECT
	fa.actor_id,
    COUNT(*) as number_of_film
FROM sakila.film_actor as fa
GROUP BY fa.actor_id
LIMIT 1;

-- Then, use the actor_id to find different film
SELECT  
	f.title 
FROM sakila.film as f
JOIN sakila.film_actor as fa ON f.film_id = fa.film_id
WHERE fa.actor_id = (
    SELECT
		fa.actor_id
	FROM sakila.film_actor as fa
	GROUP BY fa.actor_id
    ORDER BY COUNT(fa.film_id) DESC
	LIMIT 1
);

-- combine all
SELECT  
	CONCAT(a.first_name, ' ', a.last_name) as actor_name,
	f.title 
FROM sakila.actor as a
JOIN sakila.film_actor as fa ON a.actor_id = fa.actor_id
JOIN sakila.film as f ON fa.film_id = f.film_id
WHERE a.actor_id = (
    SELECT
		fa.actor_id
	FROM sakila.film_actor as fa
	GROUP BY fa.actor_id
    ORDER BY COUNT(fa.film_id) DESC
	LIMIT 1
);


-- Find the films rented by the most profitable customer
-- You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.
SELECT * FROM sakila.payment; -- payment_id, customer_id, rental_id, amount
SELECT * FROM sakila.rental; -- rental_id, inventory_id, customer_id
SELECT * FROM sakila.inventory; -- inventory_id, film_id

-- check first the most profitable customer
SELECT 
	p.customer_id,
    SUM(p.amount) as total_payment
FROM sakila.payment as p
GROUP BY customer_id
ORDER BY total_payment DESC;

-- find the films rented by most profitable customer
SELECT 
	f.title
FROM sakila.film as f
JOIN sakila.inventory as i ON f.film_id = i.film_id
JOIN sakila.rental as r ON i.inventory_id = r.inventory_id
JOIN sakila.payment as p ON r.rental_id = p.rental_id
WHERE r.customer_id = (
	SELECT 
	p.customer_id
	FROM sakila.payment as p
	GROUP BY p.customer_id
	ORDER BY SUM(p.amount) DESC
    LIMIT 1
);

-- Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. 
SELECT 
	p.customer_id,
    SUM(p.amount) as total_amount_spent
FROM sakila.payment as p
GROUP BY p.customer_id
HAVING total_amount_spent > (
	SELECT 
        AVG(total_amounts)
    FROM (
		SELECT
			p.customer_id,
			SUM(p.amount) AS total_amounts
        FROM sakila.payment AS p
        GROUP BY p.customer_id
    ) AS subquery
);

-- if we want to check the average
WITH total_spent_by_customer AS (
    SELECT 
        p.customer_id,
        SUM(p.amount) AS total_amount_spent
    FROM sakila.payment AS p
    GROUP BY p.customer_id
)
SELECT 
    AVG(ts.total_amount_spent) AS average_spent
FROM total_spent_by_customer AS ts;