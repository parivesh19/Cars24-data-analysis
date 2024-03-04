-- Insight Task :
-- Assume you are working for cars24 and the manager has given you the task below mentioned task  
-- which you have to find using `SQL` :

-- 1. Can you provide information on the least expensive and most expensive cars for each brand available at CARS24, 
-- along with their `specifications`?
-- 2. CARS 24 Manager wants you to compare the average prices of cars from each brand this year to those from last year.


USE masai;
Select * from cars24_cleaned_data;

-- 1. Can you provide information on the least expensive and most expensive cars for each brand available at CARS24, 
-- along with their `specifications`?

with Min_Max AS(
select * ,
rank()over(partition by BRAND order by CAR_PRICE desc) as rn1,
rank()over(partition by BRAND order by CAR_PRICE asc) as rn2
from cars24_cleaned_data c
)
select c.CAR_MODEL, c.BRAND, c.CAR_NAME, c.CAR_VARIANT, c.CAR_TRANSMISSION, c.KM_DRIVEN, c.OWNER_TYPE, c.FUEL_TYPE, c.REGISTRAION_ID, 
	   c.MONTHLY_EMI, c.CAR_PRICE, C.DOWNPAYMENT_AMOUNT, C.LOCATION 
from Min_Max c
where rn1=1 or rn2=1
order by BRAND;


-- 2. CARS 24 Manager wants you to compare the average prices of cars from each brand this year to those from last year.

with car_avg as
(
select BRAND,CAR_NAME,CAR_MODEL,round(avg(CAR_PRICE),2) as avg_price
from cars24_cleaned_data 
group by BRAND,CAR_NAME,CAR_MODEL
order by BRAND,CAR_NAME,CAR_MODEL desc
)
select *, lag(avg_price,1,0) over(partition by BRAND,CAR_NAME order by CAR_MODEL) as previous_year_price
from car_avg;


