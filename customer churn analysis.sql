CREATE DATABASE customer_churn;
SELECT * FROM churn;
SELECT COUNT(*) AS total_data FROM churn;

-- DATA CLEANSING & DATA PREPARATION
-- 1. Data type check
DESCRIBE churn;

-- 2. Duplicate check
SELECT customerID, 
	COUNT(*) AS total_duplicate
FROM churn
GROUP BY customerID
HAVING total_duplicate > 1;

-- 3. Missing values check
SELECT
    SUM(customerID IS NULL OR customerID = '') AS customerID,
    SUM(gender IS NULL OR gender = '') AS gender,
    SUM(SeniorCitizen IS NULL) AS SeniorCitizen,
    SUM(Partner IS NULL OR Partner = '') AS Partner,
    SUM(Dependents IS NULL OR Dependents = '') AS Dependents,
    SUM(tenure IS NULL) AS tenure,
    SUM(PhoneService IS NULL OR PhoneService = '') AS PhoneService,
    SUM(MultipleLines IS NULL OR MultipleLines = '') AS MultipleLines,
    SUM(InternetService IS NULL OR InternetService = '') AS InternetService,
    SUM(OnlineSecurity IS NULL OR OnlineSecurity = '') AS OnlineSecurity,
    SUM(OnlineBackup IS NULL OR OnlineBackup = '') AS OnlineBackup,
    SUM(DeviceProtection IS NULL OR DeviceProtection = '') AS DeviceProtection,
    SUM(TechSupport IS NULL OR TechSupport = '') AS TechSupport,
    SUM(StreamingTV IS NULL OR StreamingTV = '') AS StreamingTV,
    SUM(StreamingMovies IS NULL OR StreamingMovies = '') AS StreamingMovies,
    SUM(Contract IS NULL OR Contract = '') AS Contract,
    SUM(PaperlessBilling IS NULL OR PaperlessBilling = '') AS PaperlessBilling,
    SUM(PaymentMethod IS NULL OR PaymentMethod = '') AS PaymentMethod,
    SUM(MonthlyCharges IS NULL) AS MonthlyCharges,
    SUM(TotalCharges IS NULL) AS TotalCharges,
    SUM(Churn IS NULL OR Churn = '') AS Churn
FROM churn;

SELECT *
FROM churn
WHERE TotalCharges IS NULL;


-- KPIs
-- 1. Total Customer
SELECT COUNT(*) AS total_customers
FROM churn;
-- 2. Churn Customers
SELECT COUNT(*) AS churn_customers
FROM churn
WHERE Churn = 'Yes';
-- 3. Retained Customers
SELECT COUNT(*) AS retained_customers
FROM churn
WHERE Churn = 'No';
-- 4. Churn Rate
SELECT ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)*100 / COUNT(*), 2)  AS churn_rate
FROM churn;
-- 5. Average Tenure
SELECT ROUND(AVG(tenure),2) AS avg_tenure
FROM churn;


-- BUSINESS QUESTION
-- Which contract type has the highest churn rate?
SELECT Contract, 
	COUNT(*) AS total_customers, 
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)*100 / COUNT(*), 2)  AS churn_rate
FROM churn
GROUP BY Contract
ORDER BY churn_rate DESC;

-- Which internet service has the highest churn rate?
SELECT InternetService, 
	COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)*100 / COUNT(*), 2)  AS churn_rate
FROM churn
GROUP BY InternetService
ORDER BY churn_rate DESC;

-- Which payment method has the highest churn rate?
SELECT PaymentMethod, 
	COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)*100 / COUNT(*), 2)  AS churn_rate
FROM churn
GROUP BY PaymentMethod
ORDER BY churn_rate DESC;

-- How does churn rate vary across tenure groups?
SELECT
    CASE
        WHEN tenure <= 12 THEN '0-12 Months'
        WHEN tenure <= 24 THEN '13-24 Months'
        WHEN tenure <= 36 THEN '25-36 Months'
        WHEN tenure <= 48 THEN '37-48 Months'
        WHEN tenure <= 60 THEN '49-60 Months'
        ELSE '60+ Months'
    END AS tenure_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churn_customers,
    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate
FROM churn
GROUP BY tenure_group
ORDER BY tenure_group;

-- How do monthly charges differ between churned and retained customers?
SELECT Churn,
	ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charges
FROM churn
GROUP BY Churn;
