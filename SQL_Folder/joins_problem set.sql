-- ============================================
-- Table: companies
-- Columns: company_id, name, sector, exchange
-- ============================================
-- company_id | name        | sector       | exchange
-- -----------|-------------|--------------|----------
-- 1          | TCS         | IT           | NSE
-- 2          | Reliance    | Energy       | NSE
-- 3          | HDFC Bank   | Banking      | NSE
-- 4          | Infosys     | IT           | NSE
-- 5          | Adani Green | Energy       | NSE
--   (note: company_id 5 has NO trades — used for LEFT JOIN/anti-join examples)


-- ============================================
-- Table: trades
-- Columns: trade_id, company_id, trade_date, quantity, price
-- ============================================
-- trade_id | company_id | trade_date  | quantity | price
-- ---------|------------|-------------|----------|-------
-- 101      | 1          | 2024-01-02  | 100      | 3500
-- 102      | 1          | 2024-01-03  | 150      | 3550
-- 103      | 2          | 2024-01-02  | 200      | 2400
-- 104      | 3          | 2024-01-02  | 300      | 1600
-- 105      | 2          | 2024-01-03  | 50       | 2450
-- 106      | 4          | 2024-01-03  | 120      | 1450
-- 107      | 1          | 2024-01-04  | 80       | 3600


-- Q1: List each trade with the company name and sector.
-- Concept: INNER JOIN
-- Expected result: 7 rows (every trade matched with its company)
--   e.g. trade_id 101 | TCS | IT | 100 | 3500

SELECT t.trade_id, c.name, c.sector, t.quantity, t.price
FROM trades t
INNER JOIN companies c ON t.company_id = c.company_id;


-- Q2: List ALL companies and their trades, including companies with no trades.
-- Concept: LEFT JOIN
-- Expected result: Adani Green appears with NULLs for trade columns
--   (since company_id 5 has no matching rows in trades)


SELECT c.name, c.sector, t.trade_id, t.quantity, t.price
FROM companies c
LEFT JOIN trades t ON c.company_id = t.company_id;


-- Q3: Find companies that have never been traded.
-- Concept: LEFT JOIN + WHERE ... IS NULL (anti-join pattern)
-- Expected result: Adani Green

SELECT c.name
FROM companies c
LEFT JOIN trades t ON c.company_id = t.company_id
WHERE t.trade_id IS NULL;


-- Q4: Find total quantity traded per company (only companies that were traded).
-- Concept: INNER JOIN + GROUP BY + SUM
-- Expected result:
--   TCS       | 330  (100+150+80)
--   Reliance  | 250  (200+50)
--   HDFC Bank | 300
--   Infosys   | 120

SELECT c.name, SUM(t.quantity) AS total_quantity
FROM trades t
INNER JOIN companies c ON t.company_id = c.company_id
GROUP BY c.name;


-- Q5: Self join — find pairs of trades for the SAME company on DIFFERENT dates,
-- where the price increased from one day to the next (basic price movement check).
-- Concept: SELF JOIN
-- Expected result includes:
--   TCS: 3500 (2024-01-02) -> 3550 (2024-01-03) [increase]
--   TCS: 3550 (2024-01-03) -> 3600 (2024-01-04) [increase]
--   Reliance: 2400 (2024-01-02) -> 2450 (2024-01-03) [increase]

SELECT a.company_id, a.trade_date AS day1, a.price AS price1,
       b.trade_date AS day2, b.price AS price2
FROM trades a
JOIN trades b
  ON a.company_id = b.company_id
  AND b.trade_date > a.trade_date
  AND b.price > a.price;

**----------------------Practice Problems----------------------**
Q1)List each trade showing the company name, trade date, and price. Only show trades where the company is in the IT sector.
Ans- Select c.name, t.trade_date, t.price From trade t where c.sector = 'IT' INNER JOIN company c on c.company_id = t.company_id;


Q2) List all companies with their total number of trades. Include companies with zero trades too. Show company name and trade count.

try - Answer) Select c.name , From company c LEFT JOIN on company_id = company_id COUNT (*) as trade_count;

Q2-Answer) Select c.name From companies c LEFT JOIN trades t on company_id = company_id GROUP BY c.company_id COUNT(*) as trade_count;

Q3) INNER JOIN + GROUP BY

Find the total trade value (quantity × price) per sector. Only show sectors with total trade value above 500,000.

Hint: you need JOIN + GROUP BY + HAVING

Q3-Answer) Select c.sector , t.quantity * t.price as total_trade_value From trades t INNER JOIN companies c ON c.company_id = t.company_id GROUP BY c.sector HAVING SUM(total_trade_value) > 500000;


Q4 —ANSWER) LEFT JOIN + COUNT + filter

List all companies that have made more than 1 trade. Show company name and trade count.

Hint: you need JOIN + GROUP BY + HAVING COUNT

Answer) SELECT c.name , COUNT(*) as trade_count From trades t INNER JOIN companies c ON c.company_id = t.company_id , GROUP BY c.company_id HAVING COUNT(*) > 1;

Q5 — INNER JOIN + GROUP BY + HAVING + ORDER BY

List all sectors where the average trade price is above 2000. Show sector name, average price (rounded to 2 decimals), and total number of trades. Order by average price highest to lowest.

Hint: you need ROUND(), AVG(), COUNT(), GROUP BY, HAVING, ORDER BY

ANSWER -Q5) SELECT c.sector , AVG(t.price) as avg_price , COUNT(*) as total_trades FROM trades t INNER JOIN companies c ON c.company_id = t.company_id GROUP BY c.company_id HAVING AVG(t.price) as avg_price ROUND(avg_price) & COUNT(*) as total_trades ORDER BY (avg_price as DESC);

