SELECT
    u.id AS owner_id,
    concat(u.first_name, ' ', u.last_name) name,
    SUM(p.is_regular_savings) AS savings_count,
    SUM(p.is_a_fund) AS investment_count,
    round(SUM(s.confirmed_amount/100),2) AS total_deposits -- convert deposits from kobo to naira
FROM
    users_customuser u
JOIN
    plans_plan p ON u.id = p.owner_id
JOIN 
	savings_savingsaccount s on s.plan_id = p.id
GROUP BY
    u.id, u.name
HAVING
    savings_count > 0 AND
    investment_count > 0
ORDER BY
    total_deposits DESC;
