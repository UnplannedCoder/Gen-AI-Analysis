CREATE DATABASE analytics_db;
USE analytics_db;

-- Data table for Users data set --
CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    country VARCHAR(50),
    signup_date DATE
);

-- Table for Ai models data set --
CREATE TABLE AI_Models(
    model_id INT PRIMARY KEY,
    model_name VARCHAR(100),
    provider VARCHAR(100),
    cost_per_1k_tokens DECIMAL(10,4)
);

-- Table for the prompts from dataset--
CREATE TABLE Prompts (
    prompt_id INT PRIMARY KEY,
    user_id INT,
    model_id INT,
    prompt_text TEXT,
    prompt_category VARCHAR(100),
    created_at DATETIME
);

-- Table for  the Responses  dataset-- 
CREATE TABLE Responses (
    response_id INT PRIMARY KEY,
    prompt_id INT,
    response_text TEXT,
    response_time_seconds DECIMAL(5,2),
    created_at DATETIME
);

-- Tables for the Tokens dataset --
CREATE TABLE Tokens (
    token_id INT PRIMARY KEY,
    prompt_id INT,
    input_tokens INT,
    output_tokens INT,
    total_tokens INT,
    estimated_cost DECIMAL(10,4)
);

-- Tables for the Ratings dataset --
CREATE TABLE Ratings (
    rating_id INT PRIMARY KEY,
    response_id INT,
    rating INT,
    feedback TEXT
);

-- Tables  for the User Behavior dataset
CREATE TABLE User_Behavior_Analytics (
    analytics_id INT PRIMARY KEY,
    user_id INT,
    session_duration_minutes DECIMAL(5,2),
    prompts_used INT,
    active_days INT
);

select * from users;
select * from AI_Models;
select * from Prompts;
select * from Responses;
select * from Tokens;
select * from Ratings;
select * from User_Behavior_Analytics;



-- Phase 1 - Single Table Analysis
-- Users Table --

select * from users;

select count(user_id) from users;  -- Total Users 
select count(distinct(country)) from users; -- unique countries
select distinct(industry) from users;   -- Unique industry
select sum(daily_active_minutes) from users; -- Total active minutes 
select distinct(year(signup_date)) from users; -- Total years 

-- Find the maximum daily_active_minutes for users having subscription_plan = 'pro'
select subscription_plan , MAX(daily_active_minutes) AS max_active_minutes from users 
WHERE subscription_plan = 'pro' GROUP BY subscription_plan;

-- Average active time
select subscription_plan , avg(daily_active_minutes) as avg_active_minutes from users 
group by subscription_plan;

-- Top active users 
select  full_name , daily_active_minutes from users 
order by daily_active_minutes desc limit 5;

-- Users by Country 
select country , count(user_id) as total_user from users 
group by country order by total_user DESC;

-- count user by month and year
select year(signup_date) as YEAR , month(signup_date) as MONTH , count(user_id)  from users 
group by YEAR , MONTH order by YEAR , MONTH;




-- AI_Models Table --

select * from AI_Models;

select SUM(cost_per_1k_tokens) from AI_Models; -- Total cost per tokens
select MIN(cost_per_1k_tokens) from AI_Models; -- Minimum cost per tokens
select MAX(cost_per_1k_tokens) from AI_Models; -- Maximum cost per tokens
select AVG(cost_per_1k_tokens) from AI_Models; -- Average cost per tokens
select count(model_id) from AI_Models; -- Count Total AI Models

-- Cheapest AI Model
select model_name, provider from AI_Models
order by cost_per_1k_tokens 
limit 1;

-- Expensive AI Model
select model_name, provider from AI_Models
order by cost_per_1k_tokens desc
limit 1;

-- Difference Between Highest and Lowest Cost
select MAX(cost_per_1k_tokens) - MIN(cost_per_1k_tokens) AS price_difference
from AI_Models;




-- Prompts Table --

select * from prompts;

-- Total Number of Prompts
select COUNT(prompt_id) AS total_prompts
from Prompts;

-- Show All Unique Categories
select DISTINCT(category)
from Prompts;

-- Total Unique Prompt Categoriess
select COUNT(DISTINCT category) AS unique_categories
from Prompts;

-- Latest Prompt
select * from Prompts
ORDER BY created_at DESC
LIMIT 1;

-- Oldest Prompt
select * from Prompts
ORDER BY created_at ASC
LIMIT 1;

-- Total Prompts Per Category
select category,
COUNT(category) AS total_prompts
from Prompts
GROUP BY category;

-- Top 5 Active Users
select user_id, COUNT(prompt_id) AS total_prompts
from Prompts
GROUP BY user_id
LIMIT 5;

-- Most Used AI Model
select model_id, COUNT(prompt_id) AS usage_count
from Prompts
GROUP BY model_id
ORDER BY usage_count DESC;

-- Longest Prompt Text
select prompt_id, LENGTH(prompt_text) AS prompt_length
from Prompts
ORDER BY prompt_length DESC
LIMIT 5;




-- Response Table --

select * from responses;

select MAX(response_time_seconds) from responses; -- Maximum response time 
select MIN(response_time_seconds) from responses; -- Minimum response time
select AVG(response_time_seconds) from responses; -- Average response time 
select * from responses ORDER BY response_time_seconds LIMIT 1; -- Fastest Response
select * from responses ORDER BY response_time_seconds DESC LIMIT 1; -- Slowest Response

-- Longest Response Text
select response_id, LENGTH(response_text) AS response_length
from Responses
ORDER BY response_length DESC
LIMIT 5;

-- Average of each response status
select response_status, AVG(quality_score) from responses
GROUP BY response_status;




-- Tokens Table -- 

select * from tokens;

select SUM(input_tokens) from Tokens; -- Sum of input tokens
select MIN(input_tokens) from Tokens; -- Minimum of input tokens
select MAX(input_tokens) from Tokens; -- Maximum of input tokens
select AVG(input_tokens) from Tokens; -- Average of input tokens
select * from tokens ORDER BY input_tokens LIMIT 1; -- Lowest input tokens
select * from tokens ORDER BY input_tokens DESC LIMIT 1; -- Highest input tokens

select SUM(output_tokens) from Tokens; -- Sum of output tokens
select MIN(output_tokens) from Tokens; -- Minimum of output tokens
select MAX(output_tokens) from Tokens; -- Maximum of output tokens
select AVG(output_tokens) from Tokens; -- Average of output tokens
select * from tokens ORDER BY output_tokens LIMIT 1; -- Lowest output tokens
select * from tokens ORDER BY output_tokens DESC LIMIT 1; -- Highest output tokens

select SUM(total_tokens) from Tokens; -- Sum of input tokens
select MIN(total_tokens) from Tokens; -- Minimum of total tokens
select MAX(total_tokens) from Tokens; -- Maximum of total tokens
select AVG(total_tokens) from Tokens; -- Average of total tokens
select * from tokens ORDER BY total_tokens LIMIT 1; -- Lowest total tokens
select * from tokens ORDER BY total_tokens DESC LIMIT 1; -- Highest total tokens

select SUM(estimated_cost_usd) from Tokens; -- Sum of estimated cost
select MIN(estimated_cost_usd) from Tokens; -- Minimum of estimated cost
select MAX(estimated_cost_usd) from Tokens; -- Maximum of estimated cost
select AVG(estimated_cost_usd) from Tokens; -- Average of estimated cost
select * from tokens ORDER BY estimated_cost_usd LIMIT 1; -- Lowest estimated cost
select * from tokens ORDER BY estimated_cost_usd DESC LIMIT 1; -- Highest estimated cost




-- Ratings Table --

select * from ratings;

select SUM(rating_score) from ratings; -- Total of rating score
select AVG(rating_score) from ratings; -- Average of rating score

-- Average of rating score according to group
select feedback_comment, AVG(rating_score) 
from ratings GROUP BY feedback_comment; 

-- Average of rating score according to group arranged in ascending order 
select feedback_comment, AVG(rating_score) 
from ratings GROUP BY feedback_comment 
ORDER BY feedback_comment; 




-- User behavior analytics Table -- 

select * from user_behavior_analytics;

select * from user_behavior_analytics where most_used_category="Marketing"; -- Finding whose category is Marketing
select * from user_behavior_analytics where most_used_category="Data Analysis"; -- Finding whose category is Data Analysis
select DISTINCT(most_used_category) from user_behavior_analytics; -- Distinct Category
select DISTINCT(preferred_model) from user_behavior_analytics; -- Distinct preferred model
select DISTINCT(churn_risk) from user_behavior_analytics; -- Distinct churn risk
select COUNT(DISTINCT(most_used_category)) from user_behavior_analytics; -- Count of distinct category
select * from user_behavior_analytics where churn_risk="Medium"; -- Finding data whose risk is medium 
select user_id, login_count, preferred_model from user_behavior_analytics ORDER BY login_count LIMIT 10; -- Least Active Users
select user_id, login_count, preferred_model from user_behavior_analytics ORDER BY login_count DESC LIMIT 10; -- Most Active Users

-- Finding SUM , MIN , MAX , AVG of avg_session_duration_min
select SUM(avg_session_duration_min), 
MIN(avg_session_duration_min), MAX(avg_session_duration_min),
AVG(avg_session_duration_min)
from user_behavior_analytics;

-- Longest Session Users
SELECT * FROM User_Behavior_Analytics
ORDER BY session_duration_minutes DESC
LIMIT 10;

-- Shortest Session Users
SELECT * FROM User_Behavior_Analytics
ORDER BY session_duration_minutes
LIMIT 10;

 
-- Phase 2 - Join Based Analysis
-- 1. User + Prompt Analysis
-- Most Active Users
select U.user_id, U.full_name , COUNT(P.prompt_id) AS total_prompts
from users U 
JOIN prompts P
ON U.user_id = P.user_id 
GROUP BY U.user_id , U.full_name
ORDER BY total_prompts DESC 
LIMIT 10;

-- 2. User + Country Analysis
-- Country Generating Most Prompts
SELECT U.country, COUNT(P.prompt_id) AS total_prompts
FROM Users U
JOIN Prompts P
ON U.user_id = P.user_id
GROUP BY U.country
ORDER BY total_prompts DESC;

-- 3. Prompt + AI Model Analysis
-- Most Used AI Model
SELECT A.model_name, COUNT(P.prompt_id) AS usage_count
FROM AI_Models A
JOIN Prompts P
ON A.model_id = P.model_id
GROUP BY A.model_name
ORDER BY usage_count DESC;

-- 4. AI Model Cost Analysis
-- Total Cost Generated by Each Model
SELECT A.model_name, SUM(T.estimated_cost_usd) AS total_cost
FROM AI_Models A
JOIN Prompts P
ON A.model_id = P.model_id
JOIN Tokens T
ON P.prompt_id = T.prompt_id
GROUP BY A.model_name
ORDER BY total_cost DESC;

-- 5. Prompt + Response Analysis
-- Average Response Time by Prompt Category
select * from prompts;
select * from responses;
SELECT P.category, AVG(R.response_time_seconds) AS avg_response_time
FROM Prompts P
JOIN Responses R
ON P.prompt_id = R.prompt_id
GROUP BY P.category
ORDER BY avg_response_time DESC;

-- 6. Response + Ratings Analysis
-- Average Rating by Response Time
SELECT AVG(R.response_time_seconds) AS avg_time
FROM Responses R
JOIN Ratings RA
ON R.response_id = RA.response_id;

-- 7. User + Cost Analysis
-- Users Spending Most Tokens/Cost
SELECT U.full_name, SUM(T.total_tokens) AS total_tokens, SUM(T.estimated_cost_usd) AS total_cost
FROM Users U
JOIN Prompts P
ON U.user_id = P.user_id
JOIN Tokens T
ON P.prompt_id = T.prompt_id
GROUP BY U.full_name
ORDER BY total_cost DESC
LIMIT 10;

-- 8. Full Business Analytics Query
-- Complete AI Usage Report
SELECT U.name,
       A.model_name,
       P.prompt_category,
       T.total_tokens,
       T.estimated_cost,
       R.response_time_seconds,
       RA.rating
FROM Users U
JOIN Prompts P
ON U.user_id = P.user_id
JOIN AI_Models A
ON P.model_id = A.model_id
JOIN Tokens T
ON P.prompt_id = T.prompt_id
JOIN Responses R
ON P.prompt_id = R.prompt_id
JOIN Ratings RA
ON R.response_id = RA.response_id;


