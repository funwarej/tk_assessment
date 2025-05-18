# DataAnalytics-Assessment

This document explains the approach taken to solve various customer and transaction analytics questions using MySQL. It also outlines key challenges faced and how they were resolved.

---

## ✅ How I Imported the Database File into MySQL Workbench

1. **Created a local MySQL database**:
   - Opened MySQL Workbench
   - Created a new schema (e.g., `adashi_staging`)

2. **Loaded the `.sql` template**:
   - Navigated to `File > Open SQL Script`, then opened the `.sql` file
   - Connected to the target MySQL server
   - Ran the script to create the schema and tables

---

## 🔍 Query 1: High-Value Customers with Multiple Products - [link](https://github.com/funwarej/tk_assessment/blob/main/Assessment_Q1.sql)

**Objective:** Identify customers who have both a savings and an investment plan and rank them by total deposits.

**Approach:**
- Joined `users_customuser` with `plans_plan`
- Used `COUNT(CASE WHEN...)` to count savings and investment plans
- Filtered with `HAVING` to ensure both product types are held
- Aggregated deposits, converting from kobo to naira

**Challenges:**
- Ensuring deposits were positive and filtering by product type accurately
- Managing currency unit conversion (kobo to naira)

---

## 📊 Query 2: Transaction Frequency Categorization - [link](https://github.com/funwarej/tk_assessment/blob/main/Assessment_Q2.sql)

**Objective:** Categorize customers into high, medium, and low transaction frequency groups.

**Approach:**
- Calculated transactions per customer per month using `DATE_FORMAT`
- Averaged those to get monthly frequency
- Used `CASE` to assign frequency categories
- Ordered results using `FIELD(...)` for logical output

**Challenges:**
- Handling grouping by month in MySQL (`%Y-%m-01`)
- Ensuring accurate category cutoffs using average logic

---

## ⚠️ Query 3: Account Inactivity Alert - [link](https://github.com/funwarej/tk_assessment/blob/main/Assessment_Q3.sql)

**Objective:** Flag savings or investment plans with no inflow activity in the last 365 days.

**Approach:**
- Created a CTE (`inflow_dates`) to get last inflow per plan
- Used `DATEDIFF` to calculate inactivity
- Filtered out plans with `inactivity_days > 365`
- Identified type using `CASE` based on flags

**Challenges:**
- Couldn’t use column aliases in `WHERE`, had to repeat logic
- Made sure only active product types were considered

---

## 📈 Query 4: Customer Lifetime Value (CLV) Estimation - [link](https://github.com/funwarej/tk_assessment/blob/main/Assessment_Q4.sql)

**Objective:** Estimate CLV using total transactions and account tenure.

**Approach:**
- Computed tenure using `TIMESTAMPDIFF`
- Aggregated transaction totals and calculated profit (0.1% per transaction)
- Used CLV formula: `((total_txns / tenure) * 12 * avg_profit_per_txn)`
- Used `NULLIF` to avoid division-by-zero for recent users

**Challenges:**
- Normalizing CLV to Naira from Kobo
- Avoiding divide-by-zero using `NULLIF`
- Ensuring profit calculations were done at correct precision

---

## ✅ Summary

These queries offer actionable insights for operations, marketing, and finance teams:
- Target high-value cross-selling customers
- Segment by engagement frequency
- Detect dormant accounts
- Estimate CLV for retention and acquisition strategies

---
