CREATE TABLE IF NOT EXISTS VaultData (
    id INT PRIMARY KEY,
    securityType VARCHAR(20),
    title VARCHAR(255),
    passData JSONB,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);