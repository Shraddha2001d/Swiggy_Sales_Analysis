# 🍽️ SWIGGY SALES ANALYSIS
## 📌 Summary
Swiggy sales data analysis using SQL to build KPIs and generate actionable business insights.
## 📖 Overview
The project uses SQL Server to perform:
- Data Cleaning & Validation
- Duplicate Removal
-Dimensional Modelling (Star Schema)
-KPI Development
-Business Analysis
The final model supports analytical queries for revenue trends, customer spending patterns, cuisine performance, and location-based insights.

## ❓ Problem Statement
Food delivery platforms generate massive transactional data daily. However, raw data often contains:
- Missing values
- Blank fields
- Duplicate records
- Unstructured format
The challenge was to:
- Clean and validate the raw dataset
- Build an optimized data model (Star Schema)
- Develop KPIs for business performance analysis
- Generate actionable insights for decision-making

## 📊 Dataset
The dataset contains food delivery records with the following attributes:
- State
- City
- Order_Date
- Restaurant_Name
- Location
- Category
- Dish_Name
- Price_INR
- Rating
- Rating_Count

The raw table used: Swiggy_Data

## 🛠️ Tools and Technologies

- SQL Server
- T-SQL
- Star Schema Modelling
- Data Cleaning Techniques
- Aggregation & Analytical Queries

## 🔄 Methods
### 1️⃣ Data Cleaning
- Null value detection
- Blank/Empty string validation
- Duplicate detection using GROUP BY
- Duplicate removal using ROW_NUMBER()

### 2️⃣ Dimensional Modelling (Star Schema)
Created Dimension Tables:
- Dim_Date
- Dim_Location
- Dim_Restaurant
- Dim_Category
- Dim_Dish

Created Fact Table:
- Fact_Swiggy_Orders

This structure improves performance, scalability, and reporting efficiency.

### 3️⃣ KPI Development
Basic KPIs:
- Total Orders
- Total Revenue (INR Million)
- Average Dish Price
- Average Rating

Advanced Analysis:
- Monthly Trends
- Quarterly Trends
- Yearly Growth
- Day-of-week trends
- Top Cities by Orders & Revenue
- Top Restaurants
- Most Ordered Dishes
- Cuisine Performance
- Customer Spending Buckets
- Rating Distribution

## 📈 Key Insights
- Total of 197,401 orders were analyzed to evaluate overall sales performance.
- Revenue analysis shows strong contribution from top-performing cities, indicating geographical concentration of demand.
- Monthly and quarterly trends highlight clear seasonality patterns in order volume and revenue.
- A small group of restaurants and cuisines dominate total order volume, reflecting high customer preference concentration.
- Mid-price range (₹100–₹299) contributes the highest number of orders, indicating price-sensitive customer behavior.
- Weekend orders consistently exceed weekday orders, showing peak demand during non-working days.
- Higher-rated dishes and cuisines maintain stronger order volumes, suggesting rating-driven purchasing decisions.
  
## 🚀 Business Impact
- Helps management identify high-performing cities and restaurants
- Supports pricing strategy analysis
- Enables customer spending behavior understanding
- Improves data-driven decision-making
