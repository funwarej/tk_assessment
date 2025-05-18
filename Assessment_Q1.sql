SELECT
    u.id AS owner_id,
    concat(u.first_name, ' ', u.last_name) name,
    COUNT(CASE WHEN p.is_regular_savings = 1 and p.confirmed_amount > 0 THEN 1 END) AS savings_count,
    COUNT(CASE WHEN p.is_a_fund = 1 and p.confirmed_amount > 0 THEN 1 END) AS investment_count,
    SUM(p.confirmed_amount/100) AS total_deposits -- convert deposits from kobo to naira
FROM
    users_customuser u
JOIN
    plans_plan p ON u.id = p.owner_id
GROUP BY
    u.id, u.name
HAVING
    savings_count > 0 AND
    investment_count > 0
ORDER BY
    total_deposits DESC;
