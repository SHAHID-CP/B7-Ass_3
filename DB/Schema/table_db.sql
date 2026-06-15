-- User table-1
CREATE TABLE Users (
    user_id SERIAL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL,
    role VARCHAR(30) NOT NULL,
    phone_number VARCHAR(20),
    
    CONSTRAINT pk_users PRIMARY KEY (user_id),
    CONSTRAINT uq_users_email UNIQUE (email),
    CONSTRAINT chk_user_role CHECK (role IN ('Ticket Manager', 'Football Fan')),
    CONSTRAINT chk_email_format CHECK (email LIKE '%_@__%.__%'),
    CONSTRAINT chk_users_phone CHECK (
            phone_number IS NULL
            OR (phone_number ~ '^\+[0-9]{7,19}$')
            )
);

-- Match table-2
CREATE TABLE Matches (
    match_id SERIAL,
    fixture VARCHAR(255) NOT NULL,
    tournament_category VARCHAR(100) NOT NULL,
    base_ticket_price NUMERIC(10, 2) NOT NULL,
    match_status VARCHAR(30) NOT NULL DEFAULT 'Available',
    
    CONSTRAINT pk_matches PRIMARY KEY (match_id),
    CONSTRAINT chk_positive_price CHECK (base_ticket_price >= 0.00),
    CONSTRAINT chk_match_status CHECK (match_status IN ('Available', 'Selling Fast', 'Sold Out', 'Postponed'))
);