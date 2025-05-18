WITH customer_txns AS (
    SELECT
        s.owner_id,
        COUNT(*) AS total_transactions,
        SUM(s.amount * 0.001) AS total_profit, -- 0.1% of each transaction
        AVG(s.amount * 0.001) AS avg_profit_per_transaction
    FROM
        adashi_staging.savings_savingsaccount s
    GROUP BY
        s.owner_id
),
tenure AS (
    SELECT
        u.id AS customer_id,
		concat(u.first_name, ' ', u.last_name) name,
        TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months
    FROM
        adashi_staging.users_customuser u
)
SELECT
        t.customer_id,
        t.name,
        t.tenure_months,
        ct.total_transactions,
        ROUND(
            ((ct.total_transactions / NULLIF(t.tenure_months, 0)) * 12 * ct.avg_profit_per_transaction) /100, -- divide by 100 to convert from kobo to naira
            2
        ) AS estimated_clv
FROM
        tenure t
JOIN
        customer_txns ct ON t.customer_id = ct.owner_id
ORDER BY
    estimated_clv DESC;

