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


-- Retrieve the name and email of customers from Canada using both subqueries and joins. 
-- To use joins, you will need to identify the relevant tables and their primary and foreign keys.


-- Determine which films were starred by the most prolific actor in the Sakila database. 
-- First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in


-- Find the films rented by the most profitable customer
-- You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.


-- Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. 



