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

-- Q3: Handle NULL values with Coalesce and modify
SELECT booking_id, user_id, match_id, 
       COALESCE(payment_status, 'Action Required') AS systematic_status
FROM Bookings 
WHERE payment_status IS NULL
ORDER BY booking_id;