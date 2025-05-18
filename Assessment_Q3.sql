WITH inflow_dates AS (
    SELECT
        s.plan_id,
        MAX(s.created_on) AS last_transaction_date
    FROM
        adashi_staging.savings_savingsaccount s
    WHERE
        s.confirmed_amount > 0 -- inflows only
    GROUP BY
        s.plan_id
)
SELECT 
	p.id plan_id,
    p.owner_id,
	CASE
		WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,
    i.last_transaction_date,
    DATEDIFF(CURDATE(), i.last_transaction_date) inactivity_days
FROM
	adashi_staging.plans_plan p
LEFT JOIN 
	inflow_dates i on p.id =i.plan_id
WHERE 
    DATEDIFF(CURDATE(), i.last_transaction_date) > 365
    AND (
        (p.is_regular_savings = 1 OR p.is_a_fund = 1)
    )
order by 5 desc
