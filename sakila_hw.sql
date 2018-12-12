USE sakila;

SELECT *
FROM sakila.actor;

/*1a*/
SELECT first_name, last_name
FROM actor;

/*1b*/
SELECT UPPER(CONCAT(first_name, ' ', last_name) )
AS 'actor_name'
FROM actor;

/*2a*/
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'Joe';

/*2b*/
SELECT first_name, last_name
FROM actor
WHERE first_name LIKE 'GEN%';

/*2c*/
SELECT last_name, first_name
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name ASC;

/*2d*/
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

/*3a*/
ALTER TABLE `sakila`.`actor` 
ADD COLUMN `description` BLOB NULL;

/*3b*/
ALTER TABLE `sakila`.`actor` 
DROP COLUMN `description`;

/*4a*/
SELECT COUNT(last_name) AS 'last name count', last_name
FROM actor
GROUP BY last_name;

/*4b*/
SELECT COUNT(last_name) AS 'last name count', last_name
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) >= 2;

/*4c*/
UPDATE actor 
SET first_name = "HARPO"
WHERE first_name = "GROUCHO" AND last_name = "WILLIAMS";

/*5a*/
SHOW CREATE TABLE address;

/*6a*/
SELECT s.first_name, s.last_name, a.address
FROM staff s
JOIN address a
ON a.address_id = s.address_id;

/*6b*/
SELECT SUM(p.amount) AS 'amount charged', s.first_name, s.last_name
FROM staff s
INNER JOIN payment p
ON s.staff_id = p.staff_id
WHERE MONTH(p.payment_date) = 08 
AND YEAR(p.payment_date) = 2005
GROUP BY s.staff_id;

/*6c*/
SELECT COUNT(fa.actor_id) AS "Number of actors", f.title
FROM film_actor fa
INNER JOIN film f
ON fa.film_id = f.film_id
GROUP BY f.title;

/*6d*/
SELECT COUNT(inv.film_id) as "Inventory Count", f.title
FROM inventory inv
INNER JOIN film f
ON f.film_id = inv.film_id
WHERE f.title = "Hunchback Impossible"
GROUP BY f.title;

/*6e*/
SELECT c.first_name, c.last_name, SUM(p.amount) AS "total amount"
FROM customer c
INNER JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY c.last_name, c.first_name
ORDER BY c.last_name, c.first_name, SUM(p.amount) ASC;

/*7a*/
SELECT title, language_id
FROM film
WHERE title LIKE "Q%" OR title LIKE "K%" AND language_id IN 
(SELECT language_id
 FROM language
 WHERE name = "English");
 
 /*7b*/
 SELECT first_name, last_name
 FROM actor
 WHERE actor_id IN
 (SELECT actor_id
 FROM film_actor
 WHERE film_id IN
(SELECT film_id
FROM film
WHERE title = 'ALONE TRIP'));

/*7c*/
SELECT cs.first_name, cs.last_name, cs.email
FROM customer cs
INNER JOIN address ad
ON cs.address_id = ad.address_id
WHERE ad.city_id IN 
(SELECT cy.city_id
FROM city cy
INNER JOIN country cn
ON cn.country_id = cy.country_id
WHERE cn.country = "CANADA");

/*7d*/
SELECT title
FROM film
WHERE film_id IN
(SELECT film_id
FROM film_category
WHERE category_id IN
(SELECT category_id
FROM category
WHERE name = "FAMILY"));

/*7e*/
SELECT f.title, COUNT(i.film_id) AS 'times rented'
FROM film f
JOIN inventory i
ON (f.film_id = i.film_id)
GROUP BY i.film_id
ORDER BY COUNT(i.film_id) DESC;

/*7f*/
SELECT s.store_id AS "Store", SUM(p.amount) AS "Total revenue"
FROM staff s
INNER JOIN payment p
ON s.staff_id = p.staff_id
GROUP BY s.store_id;

/*7g*/
SELECT store_id, city, country
FROM store s
INNER JOIN address a
ON s.address_id = a.address_id
INNER JOIN city c
ON a.city_id = c.city_id
INNER JOIN country cn
ON cn.country_id = c.country_id;

/*7h*/
SELECT name, SUM(amount) AS "gross revenue"
FROM category c
INNER JOIN film_category fc
ON fc.category_id = c.category_id
INNER JOIN film f
ON f.film_id = fc.film_id
INNER JOIN inventory i
ON i.film_id = f.film_id
INNER JOIN rental r
ON r.inventory_id = i.inventory_id
INNER JOIN payment p
ON p.rental_id = r.rental_id
GROUP BY name
ORDER BY SUM(amount) DESC;

/*8a*/
CREATE VIEW category_revenue AS
SELECT name, SUM(amount) AS "gross revenue"
	FROM category c
	INNER JOIN film_category fc
	ON fc.category_id = c.category_id
	INNER JOIN film f
	ON f.film_id = fc.film_id
	INNER JOIN inventory i
	ON i.film_id = f.film_id
	INNER JOIN rental r
	ON r.inventory_id = i.inventory_id
	INNER JOIN payment p
	ON p.rental_id = r.rental_id
	GROUP BY name
	ORDER BY SUM(amount) DESC
	LIMIT 5;

/*8b*/
SELECT *
FROM category_revenue;

/*8c*/
DROP VIEW category_revenue;

