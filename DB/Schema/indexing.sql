-- user table indexing
CREATE INDEX idx_users_email ON Users (email);

-- matches table indexing
CREATE INDEX idx_matches_status              ON Matches (match_status);
CREATE INDEX idx_matches_tournament_category ON Matches (tournament_category);

-- bookings indexing
CREATE INDEX idx_bookings_user_id ON Bookings(user_id);
CREATE INDEX idx_bookings_match_id ON Bookings(match_id);
CREATE INDEX idx_bookings_payment_status ON Bookings (payment_status);