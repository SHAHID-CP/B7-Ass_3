-- User table-1
CREATE TABLE Users (
    user_id INT UNIQUE,
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

-- Match table-2
CREATE TABLE Matches (
    match_id INT UNIQUE,
    fixture VARCHAR(255) NOT NULL,
    tournament_category VARCHAR(100) NOT NULL,
    base_ticket_price NUMERIC(10, 2) NOT NULL,
    match_status VARCHAR(30) NOT NULL DEFAULT 'Available',
    
    CONSTRAINT pk_matches PRIMARY KEY (match_id),
    CONSTRAINT chk_positive_price CHECK (base_ticket_price >= 0.00),
    CONSTRAINT chk_match_status CHECK (match_status IN ('Available', 'Selling Fast', 'Sold Out', 'Postponed'))
    CONSTRAINT chk_fixure_structure CHECK ( fixture ~ '^.+ vs .+$' )
);

-- Booking table-3
CREATE TABLE Bookings (
    booking_id INT UNIQUE,
    user_id INT NOT NULL,
    match_id INT NOT NULL,
    seat_number VARCHAR(20),
    payment_status VARCHAR(30),
    total_cost NUMERIC(10, 2) NOT NULL,
    
    CONSTRAINT pk_bookings PRIMARY KEY (booking_id),
    CONSTRAINT fk_bookings_user FOREIGN KEY (user_id),
        REFERENCES Users(user_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_bookings_match FOREIGN KEY (match_id), 
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