-- Q1: Available Champions League matches with available status
SELECT match_id, fixture, TRUNC(base_ticket_price) AS base_ticket_price
FROM Matches 
WHERE tournament_category = 'Champions League' AND match_status = 'Available'
ORDER BY base_ticket_price DESC;

-- Q2: Users search using by ILIKE
SELECT user_id, full_name, email 
FROM Users 
WHERE full_name ILIKE 'Tanvir%' OR full_name ILIKE '%Haque%'
ORDER BY user_id;