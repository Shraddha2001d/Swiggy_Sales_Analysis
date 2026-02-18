
-- SWIGGY SALES ANALYSIS

Use [Swiggy DB];

select * from Swiggy_Data;

-- Data Validation And Cleaning

-- Null Check

Select
	sum(case when State is null then 1 else 0 end) as Null_State,
	sum(case when City is null then 1 else 0 end) as Null_City,
	sum(case when Order_Date is null then 1 else 0 end) as Null_Order_Date,
	sum(case when Restaurant_Name is null then 1 else 0 end) as Null_Restaurant_Name,
	sum(case when Location is null then 1 else 0 end) as Null_Location,
	sum(case when Category is null then 1 else 0 end) as Null_Category,
	sum(case when Dish_Name is null then 1 else 0 end) as Null_Dish_Name,
	sum(case when Price_INR is null then 1 else 0 end) as Null_Price_INR,
	sum(case when Rating is null then 1 else 0 end) as Null_Rating,
	sum(case when Rating_Count is null then 1 else 0 end) as Null_Rating_Count
from Swiggy_Data;

-- Blank or Empty Strings

select * 
from Swiggy_Data
where State='' or City='' or Order_Date=''or Restaurant_Name='' or Location='' or Category='' or Dish_Name='' ;

-- Duplicate Detection

Select 
State, City, Order_date, Restaurant_Name, Location, Category, Dish_Name, Price_INR, Rating, Rating_count, Count(*)
from Swiggy_Data
group by 
State, City, Order_date, Restaurant_Name, Location, Category, Dish_Name, Price_INR, Rating, Rating_count
having count(*) > 1;

-- Delete Duplication

with CTC as (
select * , ROW_NUMBER() over( 
	partition by
	State, City, Order_date, Restaurant_Name, Location, Category, Dish_Name, Price_INR, Rating, Rating_count
	order by (select null)
	)as rn 
from Swiggy_Data
)
delete from CTC where rn >1;

-- Creating Scima
-- Dimention Table

-- Date Table

create table Dim_Date(
	Date_Id int identity(1,1) primary key,
	Full_date date,
	Year int,
	Month int,
	Month_Name varchar(20),
	Quarter int,
	Day int,
	Week int
	);

Select * from Dim_Date;

-- Location Table

create table Dim_Location(
	Location_Id int identity(1,1) primary key,
	State varchar(100),
	City varchar(100),
	Location varchar(200)
	);

-- Restaurant Table

create table Dim_Restaurant(
	Restaurant_Id int identity(1,1) primary key,
	Restaurant_Name varchar(200)
	);

--Category Table

create table Dim_Category(
	Category_Id int identity(1,1) primary key,
	Category_Name varchar(200)
	);

-- Dish Table

create table Dim_dish(
	Dish_Id int identity(1,1) primary key,
	Dish_Name varchar(200)
	);

-- Fact Table

create table Fact_Swiggy_Orders(
	Order_Id int identity(1,1) primary key,
	Date_Id int,
	Price_INR decimal(10,2),
	Rating decimal(4,2),
	Rating_count int,

	Location_Id int,
	Restaurant_Id int,
	Category_Id int,
	Dish_Id int,

	foreign key (date_id) references dim_date(date_id),
	foreign key (location_id) references dim_location(location_id),
	foreign key (restaurant_id) references dim_restaurant(restaurant_id),
	foreign key (category_id) references dim_category(category_id),
	foreign key (dish_id) references dim_dish(dish_id)
	);

select * from Fact_Swiggy_Orders;

-- Insert Data In Tables

-- Dim_Date
insert into Dim_Date(Full_date, Year, Month, Month_Name, Quarter, Day,Week)
select distinct
	Order_Date,
	Year(Order_Date),
	month(Order_Date),
	datename(month, Order_Date),
	datepart(quarter, Order_Date),
	day(Order_Date),
	datepart(week, Order_Date)
from Swiggy_Data
where Order_Date is not null;

select * from Dim_Date;

--Dim_Location
insert into Dim_Location(State, City, Location)
select distinct
	State,
	City,
	Location
from Swiggy_Data;

select * from Dim_Location;

-- Dim_Restaurant
insert into Dim_Restaurant(Restaurant_Name)
	select distinct
	Restaurant_Name
from Swiggy_Data;

select * from Dim_Restaurant;

-- Dim Category
insert into Dim_Category(Category_Name)
	select distinct
	Category
from Swiggy_Data;

select * from Dim_Category;

-- Dim_Dish
insert into Dim_Dish(Dish_Name)
	select distinct
	Dish_Name
from Swiggy_Data;

select * from Dim_Dish;

-- Fact Table
insert into Fact_Swiggy_Orders(
	Date_Id,
	Price_INR,
	Rating,
	Rating_count,
	Location_Id,
	Restaurant_Id,
	Category_Id,
	Dish_Id
	)
select
	dd.Date_Id ,
	s.Price_INR,
	s.Rating,
	s.Rating_count,

	dl.Location_Id,
	dr.Restaurant_Id,
	dc.Category_Id,
	dsh.Dish_Id
from Swiggy_Data s

join Dim_Date dd
	on dd.Full_date= s.Order_Date

join Dim_Location dl
	on dl.State = s.State
	and dl.City = s.City
	and dl.Location = s.Location

join Dim_Restaurant dr
	on dr.Restaurant_Name = s.Restaurant_Name

join Dim_Category dc
	on dc.Category_Name = s.Category

join Dim_dish dsh
	on dsh.Dish_Name = s.Dish_Name;


select * from Fact_Swiggy_Orders;


select * from Fact_Swiggy_Orders f
join Dim_Date d on f.Date_Id = d.Date_Id
join Dim_Location l on f.Location_Id = l.Location_Id
join Dim_Restaurant r on f.Restaurant_Id = r.Restaurant_Id
join Dim_Category c on f.Category_Id = c.Category_Id
join Dim_dish di on f.Dish_Id = di.Dish_Id;


-- KPI's

-- Total Orders
select count(*) as Total_Orders
from Fact_Swiggy_Orders;

-- Total Revenue (INR Million)
select 
	Format(sum(convert(float,Price_INR))/1000000, 'N2') + 'INR_Million'
	as total_Revenue
from Fact_Swiggy_Orders;

-- Average Dish Price
select 
	Format(avg(convert(float,Price_INR)),'N2') + 'INR'
	as Avg_Dish_Price
from Fact_Swiggy_Orders;

-- Average Rating
select avg(rating) as Avg_Rating
from Fact_Swiggy_Orders;

-- Deep Drive Business Analysis

-- Monthly Order Trends
select
	d.Year,
	d.Month,
	d.Month_name,
	count(*) as Total_Orders
from Fact_Swiggy_Orders f join Dim_Date d
	on f.Date_Id = d.Date_Id
group by d.Year, d.Month, d.Month_name
order by count(*) desc;

select
	d.Year,
	d.Month,
	d.Month_name,
Format(sum(convert(float,Price_INR))/1000000, 'N2') + 'INR_Million'
	as Total_Revenue
from Fact_Swiggy_Orders f join Dim_Date d
	on f.Date_Id = d.Date_Id
group by d.Year, d.Month, d.Month_name
order by sum(Price_INR) desc;

-- Quarterly Order Trends
select
	d.Year,
	d.Quarter,
	count(*) as Total_Orders
from Fact_Swiggy_Orders f join Dim_Date d
	on f.Date_Id = d.Date_Id
group by d.Year, d.Quarter
order by count(*) desc;

-- Yearly Trend
select 
	d.Year,
	count(*) as Total_Orders
from Fact_Swiggy_Orders f join Dim_Date d
	on f.Date_Id = d.Date_Id
group by d.Year
order by count(*) desc;

-- Orders By Day Of Week
select 
	Datename(weekday, d.Full_Date) as Day_Name,
	count(*) as Total_Orders
from Fact_Swiggy_Orders f join Dim_Date d
	on f.Date_Id = d.Date_Id
group by Datename(weekday, d.Full_Date),Datepart(weekday, d.Full_Date)
order by Datepart(weekday, d.Full_Date) asc;

-- top 10 Cities By Order Volume
Select top 10
	l.City,
	count(*) as Total_Orders
from Fact_Swiggy_Orders f join Dim_Location l
	on l.Location_Id = f.Location_Id
group by l.City
Order by Count(*) desc;

-- top 10 Cities By Total Revenue
Select top 10
	l.City,
	Sum(f.Price_INR) as Total_Revenue
from Fact_Swiggy_Orders f join Dim_Location l
	on l.Location_Id = f.Location_Id
group by l.City
Order by Sum(f.Price_INR) desc;

-- Revenue Contribution By States
Select 
	l.State,
	Sum(f.Price_INR) as Total_Revenue
from Fact_Swiggy_Orders f join Dim_Location l
	on l.Location_Id = f.Location_Id
group by l.State
Order by Sum(f.Price_INR) desc;

-- Top 10 Restaurant By Orders
Select top 10
	r.restaurant_name,
	count(*) as Total_Orders
from Fact_Swiggy_Orders f join Dim_Restaurant r
	on r.Restaurant_Id = f.Restaurant_Id
group by r.Restaurant_Name
Order by Count(*) desc;

-- Top Categories By Order Volume
Select 
	c.Category_Name,
	count(*) as Total_Orders
from Fact_Swiggy_Orders f join Dim_Category c
	on c.Category_Id = f.Category_Id
group by c.Category_Name
Order by Count(*) desc;

-- Most Ordered Dishes
Select Top 10
	d.Dish_Name,
	count(*) as Total_Orders
from Fact_Swiggy_Orders f join Dim_dish d
	on d.Dish_Id= f.Dish_Id
group by d.Dish_Name
Order by Count(*) desc;

-- Cuisine Performance (Orders + Avg_Rating)
Select 
	c.Category_Name,
	count(*) as Total_Orders,
	Avg(f.rating) as Avg_Rating
from Fact_Swiggy_Orders f join Dim_Category c
	on c.Category_Id = f.Category_Id
group by c.Category_Name
Order by Total_Orders desc;

-- Total Orders By Price Range
select
	case
		when convert(float, Price_INR) < 100 then 'Under 100'
		when convert(float, Price_INR) between 100 and 199 then '100 - 199'
		when convert(float, Price_INR) between 200 and 299 then '200 - 299'
		when convert(float, Price_INR) between 300 and 499 then '300 - 499'
		else '500+'
	end as Price_Range,
	count(*) as Total_Orders
from Fact_Swiggy_Orders
group by 
	case
		when convert(float, Price_INR) < 100 then 'Under 100'
		when convert(float, Price_INR) between 100 and 199 then '100 - 199'
		when convert(float, Price_INR) between 200 and 299 then '200 - 299'
		when convert(float, Price_INR) between 300 and 499 then '300 - 499'
		else '500+'
	end 	
order by Total_Orders desc;

-- Rating Count Distribution (1-5)
select 
	rating,
	count(*) as Rating_Count
from Fact_Swiggy_Orders
group by rating
order by rating desc;
	
