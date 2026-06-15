-- Q1: Available Champions League matches with available status
SELECT match_id, fixture, TRUNC(base_ticket_price) AS base_ticket_price
FROM Matches 
WHERE tournament_category = 'Champions League' AND match_status = 'Available'
ORDER BY base_ticket_price DESC;