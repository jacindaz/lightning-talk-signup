CREATE TABLE users (
  username varchar(100) NOT NULL,
  created_at TIMESTAMP NOT NULL,
  avatar_url VARCHAR(255) NOT NULL,
  location VARCHAR(255),
  company VARCHAR(255),
  nickname VARCHAR(255),
  email VARCHAR(255),
  id SERIAL NOT NULL,
  uid VARCHAR(100) NOT NULL,
  provider VARCHAR(100) NOT NULL
);
