#Basic Questions
#1.Retrieve the total number of orders placed.

SELECT COUNT(ORDER_ID) as TOTAL_ORDERS FROM ORDER_DETAILS

#2.Calculate the total revenue generated from pizza sales.

SELECT 
    ROUND(SUM(QUANTITY * PRICE), 2) AS TOTAL_REVENUE
FROM
    ORDER_DETAILS
        JOIN
    PIZZAS ON ORDER_DETAILS.PIZZA_ID = PIZZAS.PIZZA_ID
ORDER BY TOTAL_REVENUE DESC;

#3.Identify the highest-priced pizza.

SELECT 
    NAME, PRICE
FROM
    PIZZAS
        JOIN
    PIZZA_TYPES ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY (PRICE) DESC
LIMIT 1;

#4.Identify the most common pizza size ordered.

SELECT 
    SIZE, COUNT(ORDER_ID) AS ORDERS
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id
GROUP BY size
ORDER BY ORDERS DESC;

#5.List the top 5 most ordered pizza types along with their quantities. 

SELECT 
    NAME, SUM(quantity)
FROM
    PIZZAS
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
        JOIN
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
GROUP BY NAME
LIMIT 5;

#Intermediate Questions:
#6.Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT 
    CATEGORY, SUM(QUANTITY) AS QUANTITY
FROM
    PIZZAS
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
        JOIN
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
GROUP BY CATEGORY
ORDER BY QUANTITY DESC;

#7.Determine the distribution of orders by hour of the day.

SELECT hour(TIME) AS HOUR,COUNT(order_id) AS ORDERS FROM ORDERS GROUP BY HOUR(TIME);

#8.Join relevant tables to find the category-wise distribution of pizzas.

SELECT CATEGORY,COUNT(NAME) FROM pizza_types GROUP BY category;

#9.Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT ROUND(AVG(QUANTITY),2) AS AVERAGE_ORDERS FROM 
(SELECT DATE,SUM(QUANTITY) AS QUANTITY FROM ORDERS JOIN order_details
ON order_details.order_id=ORDERS.ORDER_ID GROUP BY DATE) AS ORDER_QUANTITY; 
 
 #10.Determine the top 3 most ordered pizza types based on revenue.
SELECT 
    NAME, SUM(QUANTITY * PRICE) AS REVENUE
FROM
    pizza_types
        JOIN
    pizzas ON PIZZAS.PIZZA_TYPE_ID = pizza_types.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY NAME
ORDER BY REVENUE DESC
LIMIT 3;
 
#Advanced:
#11.Calculate the percentage contribution of each pizza type to total revenue.
SELECT 
    category,
    (SUM(QUANTITY * PRICE) / (SELECT 
            ROUND(SUM(QUANTITY * PRICE), 2) AS TOTAL_REVENUE
        FROM
            ORDER_DETAILS
                JOIN
            PIZZAS ON ORDER_DETAILS.PIZZA_ID = PIZZAS.PIZZA_ID
        ORDER BY TOTAL_REVENUE DESC)) * 100 AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON PIZZAS.PIZZA_TYPE_ID = pizza_types.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY category
ORDER BY REVENUE DESC;

#12.Analyze the cumulative revenue generated over time.

SELECT DATE,REVENUE,ROUND(SUM(REVENUE) OVER(ORDER BY DATE),2) AS CUM_REVENUE FROM
(SELECT DATE,ROUND(SUM(QUANTITY*PRICE),2) AS REVENUE FROM ORDERS JOIN order_details
ON order_details.order_id=ORDERS.ORDER_ID
JOIN pizzas
ON PIZZAS.pizza_id=order_details.pizza_id GROUP BY DATE) as SALES;

#13.Determine the top 3 most ordered pizza types based on revenue for each pizza category.

 SELECT category,NAME,REVENUE,RANK() OVER(ORDER BY REVENUE DESC) AS RANK_ FROM
 (SELECT category,NAME,SUM(QUANTITY*PRICE) AS REVENUE FROM pizza_types JOIN pizzas
 ON PIZZAS.PIZZA_TYPE_ID=pizza_types.pizza_type_id
 JOIN order_details
 ON order_details.pizza_id=pizzas.pizza_id GROUP BY NAME,category ORDER BY REVENUE) AS SALES;