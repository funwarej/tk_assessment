WITH transactions_per_month AS (
    SELECT
        s.owner_id,
        DATE_FORMAT(s.created_on, '%Y-%m-01') AS txn_month,
        COUNT(*) AS monthly_txn_count
    FROM
        adashi_staging.savings_savingsaccount s
    GROUP BY
        s.owner_id, txn_month
),
avg_monthly_txns AS (
    SELECT
        owner_id,
        AVG(monthly_txn_count) AS avg_txn_per_month
    FROM
        transactions_per_month
    GROUP BY
        owner_id
),
categorized_customers AS (
    SELECT
        CASE
            WHEN avg_txn_per_month >= 10 THEN 'High Frequency'
            WHEN avg_txn_per_month >= 3 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        avg_txn_per_month
    FROM
        avg_monthly_txns
)
SELECT
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_txn_per_month),0) AS avg_transactions_per_month
FROM
    categorized_customers
GROUP BY
    frequency_category
ORDER BY
    FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
