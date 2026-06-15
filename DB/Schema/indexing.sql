-- user table indexing
CREATE INDEX idx_users_email ON Users (email);

-- matches table indexing
CREATE INDEX idx_matches_status              ON Matches (match_status);
CREATE INDEX idx_matches_tournament_category ON Matches (tournament_category);