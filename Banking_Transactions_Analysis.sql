-- =====================================================
-- PROJECT: BANKING TRANSACTIONS ANALYSIS
-- TOOL: MySQL Workbench
-- DATASET: Banking Transactions
-- TABLE: bank_data.banking_transactions_cleaned
-- TOTAL ROWS: 4985
-- =====================================================

USE bank_data;

-- 1. View Sample Banking Transactions
SELECT *
FROM banking_transactions_cleaned
LIMIT 10;


-- 2. Total Number of Transactions
SELECT COUNT(*) AS Total_Transactions
FROM banking_transactions_cleaned;


-- 3. Check Unique and Duplicate Transaction IDs
SELECT COUNT(DISTINCT `Transaction ID`) AS Unique_Transactions,
COUNT(*) - COUNT(DISTINCT `Transaction ID`) AS Possible_Duplicate_ID_Rows
FROM banking_transactions_cleaned;

SELECT `Transaction ID`,
COUNT(*) AS ID_Count FROM banking_transactions_cleaned
GROUP BY `Transaction ID`
HAVING COUNT(*) > 1
ORDER BY ID_Count DESC;


-- 4. Check Missing Values in Important Columns
SELECT
    SUM(CASE WHEN `Transaction ID` IS NULL OR TRIM(`Transaction ID`) = '' THEN 1 ELSE 0 END) AS Missing_Transaction_ID,
    SUM(CASE WHEN `Transaction Date` IS NULL THEN 1 ELSE 0 END) AS Missing_Transaction_Date,
    SUM(CASE WHEN `Customer ID` IS NULL OR TRIM(`Customer ID`) = '' THEN 1 ELSE 0 END) AS Missing_Customer_ID,
    SUM(CASE WHEN `Customer Segment` IS NULL OR TRIM(`Customer Segment`) = '' THEN 1 ELSE 0 END) AS Missing_Customer_Segment,
    SUM(CASE WHEN Gender IS NULL OR TRIM(Gender) = '' THEN 1 ELSE 0 END) AS Missing_Gender,
    SUM(CASE WHEN Branch IS NULL OR TRIM(Branch) = '' THEN 1 ELSE 0 END) AS Missing_Branch,
    SUM(CASE WHEN City IS NULL OR TRIM(City) = '' THEN 1 ELSE 0 END) AS Missing_City,
    SUM(CASE WHEN `Account Product` IS NULL OR TRIM(`Account Product`) = '' THEN 1 ELSE 0 END) AS Missing_Account_Product,
    SUM(CASE WHEN `Transaction Type` IS NULL OR TRIM(`Transaction Type`) = '' THEN 1 ELSE 0 END) AS Missing_Transaction_Type,
    SUM(CASE WHEN Channel IS NULL OR TRIM(Channel) = '' THEN 1 ELSE 0 END) AS Missing_Channel,
    SUM(CASE WHEN `Transaction Amount INR` IS NULL THEN 1 ELSE 0 END) AS Missing_Transaction_Amount,
    SUM(CASE WHEN `Account Balance INR` IS NULL THEN 1 ELSE 0 END) AS Missing_Account_Balance,
    SUM(CASE WHEN `Transaction Status` IS NULL OR TRIM(`Transaction Status`) = '' THEN 1 ELSE 0 END) AS Missing_Transaction_Status
FROM banking_transactions_cleaned;


-- 5. Overall Banking Transaction KPIs
SELECT COUNT(*) AS Total_Transactions,
COUNT(DISTINCT `Customer ID`) AS Unique_Customers,
ROUND(SUM(`Transaction Amount INR`), 2) AS Total_Transaction_Amount_INR,
ROUND(AVG(`Transaction Amount INR`), 2) AS Average_Transaction_Amount_INR,
ROUND(MAX(`Transaction Amount INR`), 2) AS Highest_Transaction_Amount_INR,
ROUND(MIN(`Transaction Amount INR`), 2) AS Lowest_Transaction_Amount_INR
FROM banking_transactions_cleaned;


-- 6. Transaction Status Analysis
SELECT `Transaction Status`,
COUNT(*) AS Transaction_Count,
ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM banking_transactions_cleaned), 2) AS Transaction_Percentage,
ROUND(SUM(`Transaction Amount INR`), 2) AS Total_Transaction_Amount_INR
FROM banking_transactions_cleaned
GROUP BY `Transaction Status`
ORDER BY Transaction_Count DESC;


-- 7. Transaction Type Analysis
SELECT `Transaction Type`,
COUNT(*) AS Transaction_Count,
ROUND(SUM(`Transaction Amount INR`), 2) AS Total_Transaction_Amount_INR,
ROUND(AVG(`Transaction Amount INR`), 2) AS Average_Transaction_Amount_INR
FROM banking_transactions_cleaned
GROUP BY `Transaction Type`
ORDER BY Total_Transaction_Amount_INR DESC;


-- 8. Channel-wise Transaction Analysis
SELECT Channel,
COUNT(*) AS Transaction_Count,
ROUND(SUM(`Transaction Amount INR`), 2) AS Total_Transaction_Amount_INR,
ROUND(AVG(`Transaction Amount INR`), 2) AS Average_Transaction_Amount_INR
FROM banking_transactions_cleaned
GROUP BY Channel
ORDER BY Transaction_Count DESC;


-- 9. Account Product Analysis
SELECT `Account Product`,
COUNT(*) AS Transaction_Count,
COUNT(DISTINCT `Customer ID`) AS Unique_Customers,
ROUND(SUM(`Transaction Amount INR`), 2) AS Total_Transaction_Amount_INR
FROM banking_transactions_cleaned
GROUP BY `Account Product`
ORDER BY Total_Transaction_Amount_INR DESC;


-- 10. Customer Segment Analysis
SELECT `Customer Segment`,
COUNT(*) AS Transaction_Count,
COUNT(DISTINCT `Customer ID`) AS Unique_Customers,
ROUND(SUM(`Transaction Amount INR`), 2) AS Total_Transaction_Amount_INR,
ROUND(AVG(`Transaction Amount INR`), 2) AS Average_Transaction_Amount_INR
FROM banking_transactions_cleaned
GROUP BY `Customer Segment`
ORDER BY Total_Transaction_Amount_INR DESC;


-- 11. Branch-wise Transaction Analysis
SELECT Branch,
COUNT(*) AS Transaction_Count,
ROUND(SUM(`Transaction Amount INR`), 2) AS Total_Transaction_Amount_INR,
ROUND(AVG(`Transaction Amount INR`), 2) AS Average_Transaction_Amount_INR
FROM banking_transactions_cleaned
GROUP BY Branch
ORDER BY Total_Transaction_Amount_INR DESC;


-- 12. City-wise Transaction Analysis
SELECT City,
COUNT(*) AS Transaction_Count,
ROUND(SUM(`Transaction Amount INR`), 2) AS Total_Transaction_Amount_INR,
ROUND(AVG(`Transaction Amount INR`), 2) AS Average_Transaction_Amount_INR
FROM banking_transactions_cleaned
GROUP BY City
ORDER BY Total_Transaction_Amount_INR DESC;


-- 13. Monthly Transaction Trend
SELECT DATE_FORMAT(`Transaction Date`, '%Y-%m') AS Transaction_Month,COUNT(*) AS Transaction_Count,
ROUND(SUM(`Transaction Amount INR`), 2) AS Total_Transaction_Amount_INR,
ROUND(AVG(`Transaction Amount INR`), 2) AS Average_Transaction_Amount_INR
FROM banking_transactions_cleaned
WHERE `Transaction Date` IS NOT NULL
GROUP BY DATE_FORMAT(`Transaction Date`, '%Y-%m')
ORDER BY Transaction_Month;


-- 14. Gender-wise Transaction Analysis
SELECT Gender,
COUNT(*) AS Transaction_Count,
COUNT(DISTINCT `Customer ID`) AS Unique_Customers,
ROUND(SUM(`Transaction Amount INR`), 2) AS Total_Transaction_Amount_INR
FROM banking_transactions_cleaned
GROUP BY Gender
ORDER BY Transaction_Count DESC;


-- 15. Transaction Amount Categories
SELECT
    CASE
        WHEN `Transaction Amount INR` < 1000 THEN 'Below 1,000'
        WHEN `Transaction Amount INR` < 5000 THEN '1,000 - 4,999'
        WHEN `Transaction Amount INR` < 10000 THEN '5,000 - 9,999'
        ELSE '10,000 and above'
    END AS Transaction_Amount_Category,
    COUNT(*) AS Transaction_Count,
    ROUND(SUM(`Transaction Amount INR`), 2) AS Total_Transaction_Amount_INR
FROM banking_transactions_cleaned
WHERE `Transaction Amount INR` IS NOT NULL
GROUP BY Transaction_Amount_Category
ORDER BY MIN(`Transaction Amount INR`);


-- 16. Top 10 Customers by Total Transaction Amount
SELECT `Customer ID`,
COUNT(*) AS Transaction_Count,
ROUND(SUM(`Transaction Amount INR`), 2) AS Total_Transaction_Amount_INR,
ROUND(AVG(`Transaction Amount INR`), 2) AS Average_Transaction_Amount_INR
FROM banking_transactions_cleaned
GROUP BY `Customer ID`
ORDER BY Total_Transaction_Amount_INR DESC
LIMIT 10;


-- 17. Failed and Pending Transactions by Branch
SELECT Branch,
SUM(CASE WHEN LOWER(`Transaction Status`) = 'failed' THEN 1 ELSE 0 END) AS Failed_Transactions,
SUM(CASE WHEN LOWER(`Transaction Status`) = 'pending' THEN 1 ELSE 0 END) AS Pending_Transactions,
COUNT(*) AS Total_Transactions,
ROUND(SUM(CASE WHEN LOWER(`Transaction Status`) = 'failed' THEN 1 ELSE 0 END) * 100.0/ NULLIF(COUNT(*), 0), 2) AS Failed_Transaction_Rate_Percent
FROM banking_transactions_cleaned
GROUP BY Branch
ORDER BY Failed_Transaction_Rate_Percent DESC;


-- 18. Transaction Status by Channel
SELECT Channel,
`Transaction Status`,
COUNT(*) AS Transaction_Count,
ROUND(SUM(`Transaction Amount INR`), 2) AS Total_Transaction_Amount_INR
FROM banking_transactions_cleaned
GROUP BY Channel, `Transaction Status`
ORDER BY Channel, Transaction_Count DESC;


-- 19. Rank Branches by Total Transaction Amount
SELECT Branch,
ROUND(SUM(`Transaction Amount INR`), 2) AS Total_Transaction_Amount_INR,
DENSE_RANK() OVER (ORDER BY SUM(`Transaction Amount INR`) DESC) AS Branch_Rank
FROM banking_transactions_cleaned
GROUP BY Branch
ORDER BY Branch_Rank;

