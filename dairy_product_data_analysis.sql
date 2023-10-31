-- Number of products each dairy processor(brand) manufactures
SELECT brand, COUNT(product_name) product_count
FROM (SELECT brand, product_name, product_id
      FROM dairy_farm
      GROUP BY brand, product_name, product_id) AS inner1
GROUP BY 1
ORDER BY 2 DESC;

--creating temporary tables
-- products data within shelf life 
CREATE TEMPORARY TABLE within_shelf_life AS
SELECT *
FROM dairy_farm
WHERE recording_date < expiration_date;

--products data and after expiration
CREATE TEMPORARY TABLE after_expiration AS
SELECT *
FROM dairy_farm
WHERE recording_date >= expiration_date;

--Most popular dairy product
SELECT product_name, ROUND(AVG(quantity_sold)::numeric, 2) avg_quantity_sold
FROM within_shelf_life
GROUP BY product_name
ORDER BY 2 DESC
LIMIT 1;

--Consumers preferred dairy products across different locations.
SELECT sub3.product_name, sub3.customer_location, sub2.max_avg_quantity_sold
FROM (SELECT customer_location, max(avg_quantity_sold) max_avg_quantity_sold
      FROM (SELECT product_name, customer_location, ROUND(AVG(quantity_sold)::numeric, 2) avg_quantity_sold
            FROM within_shelf_life
            GROUP BY 1,2) AS sub1
      GROUP BY 1) AS sub2 
JOIN (SELECT product_name, customer_location, ROUND(AVG(quantity_sold)::numeric, 2) avg_quantity_sold
      FROM within_shelf_life
      GROUP BY 1,2) sub3
ON sub2.customer_location = sub3.customer_location AND sub2.max_avg_quantity_sold = sub3.avg_quantity_sold
ORDER BY 1;

--Consumers most preferred brand for each dairy product.
SELECT sub3.product_id, sub3.product_name, sub3.brand
FROM (SELECT product_name, MAX(total_quantity) max_total_quantity
      FROM (SELECT brand, product_name, ROUND(SUM(quantity_sold)::numeric,2) total_quantity
            FROM within_shelf_life
            GROUP BY 1,2) AS sub1
      GROUP BY 1) AS sub2
JOIN (SELECT product_id, brand, product_name, ROUND(SUM(quantity_sold)::numeric,2) total_quantity
      FROM within_shelf_life
      GROUP BY 1,2,3) AS sub3
ON sub3.product_name=sub2.product_name AND sub2.max_total_quantity = sub3.total_quantity
ORDER BY 1;

--Product that generates the highest revenue for each brand
SELECT inner3.brand, inner3.product_name, inner3.tot_rev
FROM (SELECT brand, MAX(tot_rev) max_rev
      FROM (SELECT brand, product_name, ROUND(SUM(total_revenue)::numeric,2) tot_rev
            FROM within_shelf_life
            GROUP BY 1,2) AS inner1
      GROUP BY 1) AS inner2
JOIN (SELECT brand, product_name, ROUND(SUM(total_revenue)::numeric,2) tot_rev
      FROM within_shelf_life
      GROUP BY 1,2) AS inner3
ON inner2.brand = inner3.brand AND inner2.max_rev=inner3.tot_rev;

--Highest sales year of each dairy product.
SELECT sub3.product_name, sub3.yearr, sub3.total_sum
FROM (SELECT product_name, MAX(total_sum) max_total
      FROM (SELECT product_name, DATE_PART('year', recording_date) yearr, ROUND(SUM(quantity)::numeric, 2) total_sum
            FROM within_shelf_life
            GROUP BY 1,2) sub1
      GROUP BY 1)sub2
JOIN (SELECT product_name, DATE_PART('year', recording_date) yearr, ROUND(SUM(quantity)::numeric, 2) total_sum
      FROM within_shelf_life
      GROUP BY 1,2) sub3
ON sub2.product_name=sub3.product_name AND sub2.max_total = sub3.total_sum
ORDER BY 2;

--Quarterly evaluation of each dairy product
SELECT product_id, product_name, DATE_PART('quarter', recording_date) quarter,
       ROUND(AVG(quantity)::numeric, 2) total_quantity
FROM (SELECT *
      FROM within_shelf_life) inner1
GROUP BY 1,2,3
ORDER BY 1,3;

-- Inventory turnover ratio of dairy products
SELECT product_id, SUM(quantity_sold) AS total_quantity_sold, 
       ROUND(AVG(quantity_in_stock)::numeric,2) AS avg_inventory_level,
       ROUND(CAST (SUM(total_revenue)/AVG(quantity_in_stock) AS numeric), 2) AS inventory_turnover_ratio
FROM after_expiration
GROUP BY product_id
ORDER BY 1;

-- Dairy products' average shelf life
SELECT product_name, ROUND(AVG(shelf_life)::numeric) AS avg_shelf_life
FROM dairy_farm
GROUP BY 1
ORDER BY 2;


