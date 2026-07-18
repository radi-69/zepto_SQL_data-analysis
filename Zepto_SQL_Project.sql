DROP table if exists zepto;


CREATE table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(100),
name VARCHAR(100) NOT NULL,
mrp NUMERIC(8,2),
discountpercent NUMERIC(8,2),
availablequantity INTEGER,
discountedsellingprice NUMERIC(8,2),
weightingms INTEGER,
outofstock BOOLEAN,
quantity INTEGER
)

--data exploration

--count of  rows
SELECT count(*) FROM zepto;

--sample data
SELECT * FROM zepto
LIMIT 10;

--null values
SELECT * FROM zepto
WHERE name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountpercent IS NULL
OR
availablequantity IS NULL
OR
discountedsellingprice IS NULL
OR
weightingms IS NULL
OR
outofstock IS NULL
OR
quantity IS NULL;

--different product category
SELECT DISTINCT category 
FROM zepto
ORDER BY category;

--products in stock vs out of stock
SELECT outofstock,count(sku_id)
FROM zepto
GROUP BY outofstock;

--product name present multiple times
SELECT name,COUNT(sku_id) as "Number of SKUs"
FROM zepto
GROUP BY name
HAVING count(sku_id)>1
ORDER BY COUNT(sku_id) DESC;


--data cleaning

--product with price = 0
SELECT * FROM zepto
WHERE discountedsellingprice=0 or mrp=0;

DELETE FROM zepto
WHERE mrp=0;

--convert paise to rupees
UPDATE zepto
SET mrp=mrp/100.0,
discountedSellingPrice=discountedSellingPrice/100.0;

select mrp,discountedSellingPrice FROM zepto;


--Q1. Find the top 10 best-value products based on the discounted percentage?
SELECT DISTINCT name,mrp,discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

--Q2. What are the products with High MRP but out of stock?
SELECT DISTINCT name,mrp
FROM zepto
WHERE outOfStock = TRUE and mrp > 300
ORDER BY mrp DESC;

--Q3. Calculate Estimated Revenue for each category.
SELECT category,
SUM(discountedSellingPrice*availableQuantity) AS totalRevenue
FROM zepto
GROUP BY category
ORDER BY totalRevenue;

--Q4. Find all products where mrp is greater than 500 and discount is less than 10%.
SELECT  DISTINCt name,mrp,discountPercent FROM zepto
WHERE mrp>500 AND discountPercent<10
ORDER BY mrp DESC,discountPercent DESC;

--Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT category,
ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

--Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name,weightInGms,discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms>=100
ORDER BY price_per_gram;

--Q7. Group the products into categories like Low,Medium,Bulk.
SELECT DISTINCT name,weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
WHEN weightInGms < 5000 THEN 'Medium'
ELSE 'Bulk'
END AS weight_category
FROM zepto;

--Q8. What is the Total Inventory Weight Per Category?
SELECT DISTINCT category,
SUM(weightInGms*availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;