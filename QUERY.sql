-- =========================================================================
-- SYSTEM: Football Ticket Booking System Database Setup Template
-- DESCRIPTION: Pseudo-DDL Template for Table Creation & Data Insertion
-- INSTRUCTIONS: Replace 'TYPE' and the constraint placeholders with your own
--               actual data types, relational keys, and check criteria.
-- =========================================================================

-- DROP TABLES IF THEY ALREADY EXIST TO PREVENT CONFLICTS
DROP TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS Matches;
DROP TABLE IF EXISTS Users;

-- =========================================================================
-- 1. CREATE USERS TABLE
-- =========================================================================
CREATE TABLE Users (
    user_id INT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL,
    role VARCHAR(30) NOT NULL,
    phone_number VARCHAR(20),
    
    CONSTRAINT pk_users PRIMARY KEY (user_id),
    CONSTRAINT uq_users_email UNIQUE (email),
    CONSTRAINT chk_user_role CHECK (role IN ('Ticket Manager', 'Football Fan')),
    CONSTRAINT chk_email_format CHECK (
            email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
        ),
    CONSTRAINT chk_users_phone CHECK (
            phone_number IS NULL
            OR (phone_number ~ '^\+[0-9]{7,19}$')
            )
);

-- =========================================================================
-- 2. CREATE MATCHES TABLE
-- =========================================================================
CREATE TABLE Matches (
    match_id INT,
    fixture VARCHAR(255) NOT NULL,
    tournament_category VARCHAR(100) NOT NULL,
    base_ticket_price NUMERIC(10, 2) NOT NULL,
    match_status VARCHAR(30) NOT NULL,
    
    CONSTRAINT pk_matches PRIMARY KEY (match_id),
    CONSTRAINT chk_positive_price CHECK (base_ticket_price >= 0.00),
    CONSTRAINT chk_match_status CHECK (match_status IN ('Available', 'Selling Fast', 'Sold Out', 'Postponed')),
    CONSTRAINT chk_fixure_structure CHECK ( fixture ~ '^.+ vs .+$' )
);

-- =========================================================================
-- 3. CREATE BOOKINGS TABLE
-- =========================================================================
CREATE TABLE Bookings (
    booking_id INT,
    user_id INT NOT NULL,
    match_id INT NOT NULL,
    seat_number VARCHAR(20),
    payment_status VARCHAR(30),
    total_cost NUMERIC(10, 2) NOT NULL,
    
    CONSTRAINT pk_bookings PRIMARY KEY (booking_id),
    CONSTRAINT fk_bookings_user FOREIGN KEY (user_id)
        REFERENCES Users(user_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_bookings_match FOREIGN KEY (match_id) 
        REFERENCES Matches(match_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_positive_total_cost CHECK (total_cost >= 0.00),
    CONSTRAINT chk_payment_status  CHECK (
            payment_status IS NULL
            OR payment_status IN ('Pending', 'Confirmed', 'Cancelled', 'Refunded')
        ),
    CONSTRAINT chk_seat_number CHECK (
            seat_number IS NULL
            OR seat_number ~ '^[A-Z]+-[0-9]{2,5}$'
        )
);

-- ── Indexes on Table ─────────────────────────────────────────────────────
-- user table indexing
CREATE INDEX idx_users_email ON Users (email);

-- matches table indexing
CREATE INDEX idx_matches_status              ON Matches (match_status);
CREATE INDEX idx_matches_tournament_category ON Matches (tournament_category);

-- bookings indexing
CREATE INDEX idx_bookings_user_id ON Bookings(user_id);
CREATE INDEX idx_bookings_match_id ON Bookings(match_id);
CREATE INDEX idx_bookings_payment_status ON Bookings (payment_status);

-- =========================================================================


-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO USERS
-- =========================================================================
INSERT INTO Users (user_id, full_name, email, role, phone_number) VALUES
(1, 'Tanvir Rahman', 'tanvir@mail.com', 'Football Fan', '+8801711111111'),
(2, 'Asif Haque', 'asif@mail.com', 'Football Fan', '+8801722222222'),
(3, 'Sajjad Rahman', 'sajjad@mail.com', 'Ticket Manager', '+8801733333333'),
(4, 'Jannat Ara', 'jannat@mail.com', 'Football Fan', NULL);

-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO MATCHES
-- =========================================================================
INSERT INTO Matches (match_id, fixture, tournament_category, base_ticket_price, match_status) VALUES
(101, 'Real Madrid vs Barcelona', 'Champions League', 150.00, 'Available'),
(102, 'Man City vs Liverpool', 'Premier League', 120.00, 'Selling Fast'),
(103, 'Bayern Munich vs PSG', 'Champions League', 130.00, 'Available'),
(104, 'AC Milan vs Inter Milan', 'Serie A', 90.00, 'Sold Out'),
(105, 'Juventus vs Roma', 'Serie A', 80.00, 'Available');

-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO BOOKINGS
-- =========================================================================
INSERT INTO Bookings (booking_id, user_id, match_id, seat_number, payment_status, total_cost) VALUES
(501, 1, 101, 'A-12', 'Confirmed', 150.00),
(502, 1, 102, 'B-04', 'Confirmed', 120.00),
(503, 2, 101, 'A-13', 'Confirmed', 150.00),
(504, 2, 101, NULL, NULL, 150.00),
(505, 3, 102, 'C-20', 'Pending', 120.00);

-- =========================================================================
-- 7 SQL QUERIES
-- =========================================================================

-- Q1: Available Champions League matches with available status
SELECT match_id, fixture, TRUNC(base_ticket_price) AS base_ticket_price
FROM Matches 
WHERE tournament_category = 'Champions League' AND match_status = 'Available'
ORDER BY match_id;

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

-- Q4: Inner Join for booking, user and match details
SELECT booking_id,full_name,fixture,TRUNC(total_cost) AS total_cost
FROM Bookings
INNER JOIN Users ON Bookings.user_id = Users.user_id
INNER JOIN Matches ON Bookings.match_id = Matches.match_id
ORDER BY booking_id;

-- Q5: Left Join all users
SELECT Users.user_id, Users.full_name, Bookings.booking_id 
FROM Users
LEFT JOIN Bookings ON Users.user_id = Bookings.user_id
ORDER BY Users.user_id,Bookings.user_id;

-- Q6: Subquery and filtering above average cost
SELECT booking_id, match_id, TRUNC(total_cost) AS total_cost
FROM Bookings 
WHERE total_cost > (SELECT AVG(total_cost) FROM Bookings)
ORDER BY total_cost DESC;

-- Q7: Pagination Offset and Limit
SELECT match_id, fixture, TRUNC(base_ticket_price) AS base_ticket_price 
FROM Matches 
ORDER BY base_ticket_price DESC
LIMIT 2 OFFSET 1;